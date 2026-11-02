$(document).ready(function() {
  $('#doc-content').toc({
    renderIn: '#page-toc',
    anchorPrefix: 'tocAnchor-', // the default prefix used for generated TOC elements IDs
    showAlways: true, //Show TOC also if only one H1 is present on page, the TOC is never show if no H1s are found on page
    saveShowStatus: false, // Save the collapse status using a cookie (see dependecies for further details)
    contentsText: 'Contents', // The label text shown for Content, you can localize passing another string
    hideText: 'hide', // The label text shown for hide button, you can localize passing another string
    showText: 'show' // The label text shown for show button, you can localize passing another string
  })
})
