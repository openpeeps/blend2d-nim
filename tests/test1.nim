import unittest
import std/os

import blend2d

test "filled background":
  group main, 200, 200:
    this.fillStyle(colSalmon)
  main.exportAs("tests" / "out" / "filled.png")

test "draw circle + stroke":
  group mainImage, 200, 200:
    let sun = circle(100, 100, 50)
    sun.stroke(50, rgba(242,224,171,255))
    this.add(sun.addr, rgba(230,197,115,255))
  mainImage.exportAs("tests" / "out" / "circle.png")

test "draw gradient":
  group img, 480, 480:
    let
      blRoundRect = roundRect(180, 180, 120, 120, 25, 25)
      linearGradient = linearGradient(0, 0, 0, 480)
    linearGradient.add(0.0, ColorHex(0xFFFFFFFF))
    linearGradient.add(0.5, ColorHex(0xFF5FAFDF))
    linearGradient.add(1.0, ColorHex(0xFF2F5FDF))

    this.fill(colWhitesmoke)
    this.add(blRoundRect.addr, linearGradient)
    this.add(img)

  img.exportAs("tests" / "out" / "gradient.png")

test "draw profile":
  group main, 700, 700:
    this.fill(colSalmon)
    let area = rect(190, 140, 320, 400, 25, 25)
    this.add(area.addr, colWhite)
  main.exportAs("tests" / "out" / "ui.png")