// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import Plyr from "plyr";
import "./controllers";

console.log('TSTEET')

function initializeVideoPlayer() {
    console.log("Initializing video player");
    const playerElement = document.getElementById("player");
    if (!playerElement) {
        console.log("No video player element found");
        return;
    }

    // Check if Plyr is already initialized on this element
    if (playerElement.plyr) {
        console.log("Plyr already initialized, destroying previous instance");
        playerElement.plyr.destroy();
    }

    const player = new Plyr(playerElement, {
        controls: [
            'play-large',
            'play',
            'progress',
            'current-time',
            'mute',
            'volume',
            'settings',
            'fullscreen'
        ],
        settings: ['quality', 'speed', 'loop'],
        quality: {
            default: 720,
            options: [4320, 2880, 2160, 1440, 1080, 720, 576, 480, 360, 240],
            forced: true,
            onChange: (quality) => {
                console.log(`Quality changed to ${quality}`);
            }
        }
    });
    console.log("Plyr video player initialized", player);

    return player;
}

document.addEventListener("turbo:load", () => {
    console.log("Turbo load event detected");
    initializeVideoPlayer();
});

// Listen for turbo frame loads (when frames are replaced)
document.addEventListener("turbo:frame-load", () => {
    console.log("Turbo frame load event detected");
    initializeVideoPlayer();
});

// Listen for turbo stream actions (alternative approach)
document.addEventListener("turbo:before-stream-render", () => {
    console.log("Turbo stream render event detected");
    // Initialize player after a short delay to ensure DOM is updated
    setTimeout(() => {
        initializeVideoPlayer();
    }, 100);
});
