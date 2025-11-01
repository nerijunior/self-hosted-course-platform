// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import Plyr from "plyr";
import "./controllers";

const player = new Plyr("#player");
