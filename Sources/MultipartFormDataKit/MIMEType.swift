public struct MIMEType {
    public var text: String

    public init(text: String) {
        self.text = text
    }

    public static var multipartFormData = MIMEType(text: "multipart/form-data")

    public static var textPlain = MIMEType(text: "text/plain")
    public static var textHtml = MIMEType(text: "text/html")
    public static var textCss = MIMEType(text: "text/css")
    public static var textJavascript = MIMEType(text: "text/javascript")

    public static var imageGif = MIMEType(text: "image/gif")
    public static var imagePng = MIMEType(text: "image/png")
    public static var imageJpeg = MIMEType(text: "image/jpeg")
    public static var imageBmp = MIMEType(text: "image/bmp")
    public static var imageWebp = MIMEType(text: "image/webp")
    public static var imageSvgXml = MIMEType(text: "image/svg+xml")

    public static var audioAudio = MIMEType(text: "audio/midi")
    public static var audioMpeg = MIMEType(text: "audio/mpeg")
    public static var audioWebm = MIMEType(text: "audio/webm")
    public static var audioOgg = MIMEType(text: "audio/ogg")
    public static var audioWav = MIMEType(text: "audio/wav")

    public static var videoWebm = MIMEType(text: "video/webm")
    public static var videoOgg = MIMEType(text: "video/ogg")

    public static var applicationOctetStream = MIMEType(text: "application/octet-stream")
    public static var applicationXml = MIMEType(text: "application/xml")
    public static var applicationJson = MIMEType(text: "application/json")
}