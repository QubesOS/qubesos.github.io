#!/usr/bin/env ruby

require 'kramdown'



YamlFrontMatter = Struct.new(:yaml_lines, :startl, :endl)

def get_yaml_front_matter(gfm_lines)
    counter = 0
    startl = 0
    endl = 0
    for i in 0..(gfm_lines.length - 1)
        if gfm_lines[i] == "---\n"
            counter += 1
            if counter == 1
                startl = i
            elsif counter == 2
                endl = i + 1
                result = YamlFrontMatter.new
                result.yaml_lines = gfm_lines[startl..(endl - 1)]
                result.startl = startl
                result.endl = endl
                return result
            end
        end
    end
    if counter == 1
        result = YamlFrontMatter.new
        result.yaml_lines = gfm_lines[startl..-1]
        result.startl = startl
        result.endl = gfm_lines.length
        return result
    end
    # case counter == 0:
    result = YamlFrontMatter.new
    result.yaml_lines = []
    result.startl = 0
    result.endl = 0
    return result
end



def line_only_made_of(line, char)
    length = line.length
    for i in 0..(length - 2)
        if line[i] != char
            return false
        end
    end
    return line[length - 1] == "\n"
end



def render(gfm_lines)
  Kramdown::Document.new(gfm_lines.join).to_html.lines
end



LineColumn = Struct.new(:l, :c)

def look_for_headline(rendered_html_lines, headline_id)
    for l in 0..(rendered_html_lines.length - 1)
        m = rendered_html_lines[l].scan(/<h\d\s+id\s*=\s*"#{headline_id}"\s*>/)
        if m.length > 0
            c = rendered_html_lines[l].index(m[0])
            result = LineColumn.new
            result.l = l
            result.c = c
            return result
        end
    end
    return nil
end



def extract_headline_id(rendered_html_lines, l, c)
    line = rendered_html_lines[l]
    line = line[c..-1]
    m = line.scan(/<h\d\s+id\s*=\s*"/)
    if m.length == 0
        return nil
    end
    col = line.index(m[0])
    start_idx = col + m[0].length
    end_idx = line.index('"', start_idx)
    line = line[start_idx..(end_idx - 1)]
    return line
end



def try_get_headline_column_and_line(gfm_lines, line_number, placeholder)
    # save headline
    saved_headline = gfm_lines[line_number]

    this_line = gfm_lines[line_number].to_s
    if this_line.eql? ""
        return nil
    end

    if line_number < gfm_lines.length - 1
        next_line = gfm_lines[line_number + 1].to_s
    else
        next_line = ""
    end

    hl = nil

    if this_line.start_with?('#')
        # headline starting with '#'
        gfm_lines[line_number] = '# ' + placeholder + "\n"
        hl = look_for_headline(render(gfm_lines), placeholder)
    elsif next_line.length >= 3 and (line_only_made_of(next_line, '=') or line_only_made_of(next_line, '-'))
        # headline starting with '===' or '---'
        gfm_lines[line_number] = placeholder + "\n"
        hl = look_for_headline(render(gfm_lines), placeholder)
    end

    # revert headline
    gfm_lines[line_number] = saved_headline

    return hl
end



def generate_unique_placeholder(rendered_html_lines)
    number = 0
    prefix = 'xq'
    suffix = 'z'
    result = ''
    while true do
        result = prefix + number.to_s + suffix
        solution_found = true
        for line in rendered_html_lines
            if line.include? result
                number += 1
                solution_found = false
                break
            end
        end
        if solution_found
            break
        end
    end
    # we assume that there will be at least one solution
    return result
end



def create_id_list(gfm_lines)
    result = []
    gfm_lines2 = gfm_lines[0..-1]
    rendered_html_lines = render(gfm_lines)

    placeholder = generate_unique_placeholder(rendered_html_lines)

    # line-by-line: assume a headline
    n = gfm_lines2.length
    for line_number in 0..(n - 1)
        hl = try_get_headline_column_and_line(gfm_lines2, line_number, placeholder)
        if hl != nil
            hid = extract_headline_id(rendered_html_lines, hl.l, hl.c)
            result = result + [hid]
        end
    end
    return result
end



def is_a_headline(gfm_lines, line_number, placeholder)
    return try_get_headline_column_and_line(gfm_lines, line_number, placeholder) != nil
end



def insert_ids_into_gfm_file(id_list, gfm_lines)
    result = gfm_lines[0..-1]
    if id_list.length == 0
        return result
    end
    n = result.length
    rendered_html_lines = render(gfm_lines)
    placeholder = generate_unique_placeholder(rendered_html_lines)
    id_index = 0

    for line_number in 0..(gfm_lines.length - 1)
        if is_a_headline(gfm_lines, line_number, placeholder)
            id = id_list[id_index]
            if id != nil
                str_to_insert = '<a id="' + id + '"></a>' + "\n"
                line = result[line_number]
                if !line.nil? and line.start_with?('#')
                    if line_number + 1 >= n
                        result = result + ['']
                    end
                    result[line_number + 1] = str_to_insert.to_s + result[line_number + 1].to_s
                else
                    if line_number + 2 >= n
                        result = result + ['']
                    end
                    result[line_number + 2] = str_to_insert.to_s + result[line_number + 2].to_s
                end
            end
            id_index += 1
            if id_index >= id_list.length
                break
            end
        end
    end
    return result
end



def merge_ids_in_gfm_files(orig_gfm_lines, trl_gfm_lines)
    # assuming that both files match line by line such that matching headlines are in the same lines

    # get yaml front matter from orig
    orig_yfm = get_yaml_front_matter(orig_gfm_lines)
    orig_yaml_front_matter = orig_yfm.yaml_lines
    orig_start = orig_yfm.startl
    orig_end = orig_yfm.endl

    # get yaml front matter from trl
    trl_yfm = get_yaml_front_matter(trl_gfm_lines)
    trl_yaml_front_matter = trl_yfm.yaml_lines
    trl_start = trl_yfm.startl
    trl_end = trl_yfm.endl

    # get body from trl
    trl_body = trl_gfm_lines[trl_end..-1]

    # get body from orig
    orig_body = orig_gfm_lines[orig_end..-1]

    # create id list
    orig_id_list = create_id_list(orig_body)

    # insert ids
    preresult = insert_ids_into_gfm_file(orig_id_list, trl_body)

    # create translated document with adapted body
    result_trl_gfm = trl_yaml_front_matter.join + preresult.join

    return result_trl_gfm
end

def create_dict_from_tx_config(lang, mappingfile)
    # read a tx.xonfig file containing only file_filter and source_file information store it in a dict and give it back
    # mappingfile:  a tx.xonfig file containing only file_filter and source_file information
    # return: a dict containing a mapping between an original file and its downloaded tx translation
    mapping = {}

    lines = []
    lines = read_file(mappingfile)

    translated = []
    source = []
    n = lines.length
    idx = 0
    while idx < n do
        t = lines[idx].split('file_filter =')[1].strip
        s = lines[idx+1].split('source_file =')[1].strip
        translated += ["./" + t.gsub("<lang>", lang)]
        if idx >= n then
            break
        end
        source += ["./" + s]
        idx += 2 
    end

    n = translated.length
    idx = 0
    while idx < n do
        mapping[source[idx]] = translated[idx]
        idx += 1
    end

    return mapping
end

def read_file(filename)
    read_lines = []
    File.open(filename, "r") do |f|
        f.each_line do |line|
            read_lines += [line]
        end
    end
    return read_lines
end

def write_file(contents, filename)
    read_lines = []
    File.open(filename, "w") do |f|
        f.write(contents)
    end
end

def main()
    if ARGV.length != 2
        exit(1)
    end

    mapping = create_dict_from_tx_config(ARGV[0], ARGV[1])
    mapping.each do |key, value|
        if !key.end_with?(".yml")
            orig_gfm_lines = read_file(key)
            trl_gfm_lines = read_file(value)
            # merge ids in gfm files
            result = merge_ids_in_gfm_files(orig_gfm_lines, trl_gfm_lines)
            write_file(result, value)
        end
    end

end


if __FILE__ == $0
    main()

    # --- for debugging
    # orig_gfm_lines = read_file(ARGV[0])
    # trl_gfm_lines = read_file(ARGV[1])
    # result = merge_ids_in_gfm_files(orig_gfm_lines, trl_gfm_lines)
    # write_file(result, '/dev/stdout')
end

