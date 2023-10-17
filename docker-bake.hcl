group default {
  targets = ["release"]
}

variable "MEDIATHEK_VERSION" {
  default = "$MEDIATHEK_VERSION"
}

target "image" {
  args = {}
  platforms = ["linux/amd64", "linux/arm64"]
}

target "release" {
  inherits = ["image"]
  args = {
    MEDIATHEK_VERSION = "${MEDIATHEK_VERSION}"
  }
  tags = ["bate/mediathekview-webinterface:${MEDIATHEK_VERSION}", "bate/mediathekview-webinterface:latest"]
}
