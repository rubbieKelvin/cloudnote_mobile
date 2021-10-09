function fromString(source, options){
    options = options || {}
    const color = options.color || "black"

    let style = `color: ${color};`
    if (options.width) style = style+` width: ${options.width};`
    if (options.height) style = style+` height: ${options.height};`

    source = source.replace("<svg", `<svg style="${style}"`)
    return `data:image/svg+xml;utf8, ${source}`
}