"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const fluent_ffmpeg_1 = __importDefault(require("fluent-ffmpeg"));
const app = (0, express_1.default)();
app.use(express_1.default.json);
app.get("/", (req, res) => {
    console.log("User visiting home");
    res.send("Hello Galaxy");
});
app.post("/process", (req, res) => {
    const inFilePath = req.body.inputFilePath;
    const outFilePath = req.body.outputFilePath;
    if (!inFilePath || !outFilePath) {
        res.status(400).send('Bad Request: Missing input file path/ out file path');
    }
    (0, fluent_ffmpeg_1.default)(inFilePath)
        .outputOptions("-vf", "scale=-1:360")
        .on("end", () => {
        res.status(200).send("Video processing started.");
    })
        .on("error", (err) => {
        console.log(`An error occurred: ${err.message}`);
        res.status(500).send('Internal Server Error: ${err.message}');
    })
        .save(outFilePath);
});
const port = 8000;
app.listen(port, () => {
    console.log('Video server ready');
});
