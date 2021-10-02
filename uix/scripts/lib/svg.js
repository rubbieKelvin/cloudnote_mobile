function fromString(source, options){
    options = options || {}
    const color = options.color || "black"
    const style = `color: ${color};`
    source = source.replace("<svg", `<svg style="${style}"`)
    return `data:image/svg+xml;utf8, ${source}`
}