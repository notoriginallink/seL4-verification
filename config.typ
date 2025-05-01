#import "@preview/typslides:1.2.5": *
#import "@preview/colorful-boxes:1.4.2": *


#let code( 
  lang: "c",
  bg-color: rgb("#F5F5F5"),
  border-color: rgb("#4682B4"),
  body
) = {
  set text(font: "Consolas", size: 20pt)
  box(
    fill: bg-color,
    stroke: 1pt + border-color,
    radius: 4pt,
    inset: 8pt,
    width: 100%,
  )[
    #raw(block: true, lang: lang, body)
  ]
}

#let Purple(a: 100) = rgb(128, 0, 128, a)

#let hint-box(body) = box(fill: Purple(a: 30), width: 100%, inset: 8pt, body)