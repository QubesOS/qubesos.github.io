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



def try_create_id(gfm_lines, line_number, this_line, next_line, rendered_html_lines, placeholder)
    # save headline
    saved_headline = gfm_lines[line_number]

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

    if hl == nil
        return nil
    end

    return extract_headline_id(rendered_html_lines, hl.l, hl.c)
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



def create_line_to_id_map(gfm_lines)
    result = {}
    gfm_lines2 = gfm_lines[0..-1]
    rendered_html_lines = render(gfm_lines)

    placeholder = generate_unique_placeholder(rendered_html_lines)

    # line-by-line: assume a headline
    n = gfm_lines2.length
    for i in 0..(n - 1)
        this_line = gfm_lines2[i]
        next_line = ''
        if i < n - 1
            next_line = gfm_lines2[i + 1]
        end
        hid = try_create_id(gfm_lines2, i, this_line, next_line, rendered_html_lines, placeholder)
        if hid != nil
            result[i] = hid
        end
    end
    return result
end



def insert_ids_to_gfm_file(line_to_id_map, gfm_lines)
    result = gfm_lines[0..-1]
    n = result.length
    line_to_id_map.each do |key, value|
        str_to_insert = '<a id="' + value + '"></a>'
        line = result[key]
        if !line.nil? and line.start_with?('#')
            if key + 1 >= n
                result = result + ['']
            end
            result[key + 1] = str_to_insert.to_s + result[key + 1].to_s
        else
            if key + 2 >= n
                result = result + ['']
            end
            result[key + 2] = str_to_insert.to_s + result[key + 2].to_s
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

    # create line-to-id map
    orig_line_to_id_map = create_line_to_id_map(orig_body)

    # insert ids
    preresult = insert_ids_to_gfm_file(orig_line_to_id_map, trl_body)

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
end

