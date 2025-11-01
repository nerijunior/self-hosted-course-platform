// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import Plyr from "plyr";
import "./controllers";

// Global variable to track if keyboard listener is already added
let keyboardListenerAdded = false;
let currentPlayer = null;

function addKeyboardShortcuts(player) {
    // Remove existing listener if any
    if (keyboardListenerAdded) {
        document.removeEventListener('keydown', handleKeydown);
    }

    currentPlayer = player;

    // Add new listener
    document.addEventListener('keydown', handleKeydown);
    keyboardListenerAdded = true;
}

function handleKeydown(e) {
    const player = currentPlayer;
    if (!player) return;

    // Only skip if focused on input/textarea elements
    if (document.activeElement.matches('input, textarea')) {
        return;
    }

    console.log(`Key pressed: "${e.key}", Code: "${e.code}", Shift: ${e.shiftKey}`);

    switch (e.key) {
        case ' ':
        case 'k':
            e.preventDefault();
            player.togglePlay();
            break;
        case 'ArrowLeft':
            e.preventDefault();
            player.rewind(10);
            break;
        case 'ArrowRight':
            e.preventDefault();
            player.forward(10);
            break;
        case 'ArrowUp':
            e.preventDefault();
            player.increaseVolume(0.1);
            break;
        case 'ArrowDown':
            e.preventDefault();
            player.decreaseVolume(0.1);
            break;
        case 'm':
            e.preventDefault();
            player.muted = !player.muted;
            break;
        case 'f':
            e.preventDefault();
            player.fullscreen.toggle();
            break;
        case ',':
        case '<':
            // Shift + , (which gives <) : Decrease speed
            if (e.shiftKey) {
                e.preventDefault();
                console.log('Decreasing speed...');
                const currentSpeed = player.speed;
                const speeds = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];
                const currentIndex = speeds.indexOf(currentSpeed);
                if (currentIndex > 0) {
                    player.speed = speeds[currentIndex - 1];
                    console.log(`Speed decreased to ${player.speed}x`);
                }
            }
            break;
        case '.':
        case '>':
            // Shift + . (which gives >) : Increase speed
            if (e.shiftKey) {
                e.preventDefault();
                console.log('Increasing speed...');
                const currentSpeed = player.speed;
                const speeds = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];
                const currentIndex = speeds.indexOf(currentSpeed);
                if (currentIndex < speeds.length - 1) {
                    player.speed = speeds[currentIndex + 1];
                    console.log(`Speed increased to ${player.speed}x`);
                }
            }
            break;
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
            e.preventDefault();
            const percentage = parseInt(e.key) * 10;
            player.currentTime = (player.duration * percentage) / 100;
            break;
    }

    // Alternative approach using keyCode for speed controls
    if (e.shiftKey) {
        if (e.code === 'Comma' || e.code === 'Period') {
            e.preventDefault();
            const currentSpeed = player.speed;
            const speeds = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];
            const currentIndex = speeds.indexOf(currentSpeed);

            if (e.code === 'Comma' && currentIndex > 0) {
                // Shift + Comma (< key) - Decrease speed
                player.speed = speeds[currentIndex - 1];
                console.log(`Speed decreased to ${player.speed}x (via code)`);
            } else if (e.code === 'Period' && currentIndex < speeds.length - 1) {
                // Shift + Period (> key) - Increase speed
                player.speed = speeds[currentIndex + 1];
                console.log(`Speed increased to ${player.speed}x (via code)`);
            }
        }
    }
}

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
            'restart',
            'rewind',
            'play',
            'fast-forward',
            'progress',
            'current-time',
            'duration',
            'mute',
            'volume',
            'captions',
            'settings',
            'pip',
            'airplay',
            'fullscreen'
        ],
        settings: ['captions', 'quality', 'speed'],
        quality: {
            default: 720,
            options: [1080, 720],
        },
        speed: {
            selected: 1,
            options: [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2]
        },
        keyboard: {
            focused: true,
            global: false // We'll handle our own keyboard shortcuts
        },
        tooltips: {
            controls: true,
            seek: true
        },
        resetOnEnd: false,
        // Performance optimizations for faster loading
        autopause: false,
        preload: 'metadata', // Load video metadata immediately
        crossorigin: false,
        playsinline: true,
        storage: {
            enabled: true,
            key: 'plyr-lessons' // Store player preferences
        }
    });

    // Create and show loading spinner
    function createLoadingSpinner() {
        const spinner = document.createElement('div');
        spinner.id = 'video-loading-spinner';
        spinner.innerHTML = `
            <div class="spinner-container">
                <div class="spinner"></div>
                <div class="loading-text">Carregando...</div>
            </div>
        `;
        spinner.style.cssText = `
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            backdrop-filter: blur(4px);
        `;

        // Add CSS for spinner if not already added
        if (!document.querySelector('#spinner-styles')) {
            const style = document.createElement('style');
            style.id = 'spinner-styles';
            style.textContent = `
                .spinner-container {
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    gap: 16px;
                }
                
                .spinner {
                    width: 48px;
                    height: 48px;
                    border: 4px solid rgba(255, 255, 255, 0.3);
                    border-left-color: #ff0000;
                    border-radius: 50%;
                    animation: spin 1s linear infinite;
                }
                
                .loading-text {
                    color: white;
                    font-size: 16px;
                    font-weight: 500;
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                }
                
                @keyframes spin {
                    0% { transform: rotate(0deg); }
                    100% { transform: rotate(360deg); }
                }
            `;
            document.head.appendChild(style);
        }

        return spinner;
    }

    function showLoadingSpinner() {
        // Remove existing spinner if any
        const existingSpinner = document.querySelector('#video-loading-spinner');
        if (existingSpinner) {
            existingSpinner.remove();
        }

        const spinner = createLoadingSpinner();
        const playerContainer = player.elements.container;
        playerContainer.style.position = 'relative';
        playerContainer.appendChild(spinner);

        console.log('Loading spinner shown');
    }

    function hideLoadingSpinner() {
        const spinner = document.querySelector('#video-loading-spinner');
        if (spinner) {
            spinner.style.opacity = '0';
            spinner.style.transition = 'opacity 0.3s ease-out';
            setTimeout(() => {
                if (spinner.parentNode) {
                    spinner.remove();
                }
            }, 300);
            console.log('Loading spinner hidden');
        }
    }

    // Show spinner immediately when player is created
    showLoadingSpinner();

    // YouTube-like keyboard shortcuts
    player.on('ready', () => {
        console.log("Player ready, adding YouTube-like features");
        addKeyboardShortcuts(player);
    });

    // Loading state management
    player.on('loadstart', () => {
        console.log('Video load started');
        showLoadingSpinner();
    });

    player.on('loadeddata', () => {
        console.log('Video data loaded');
        hideLoadingSpinner();
    });

    player.on('canplay', () => {
        console.log('Video can start playing');
        hideLoadingSpinner();
    });

    player.on('waiting', () => {
        console.log('Video is buffering');
        showLoadingSpinner();
    });

    player.on('canplaythrough', () => {
        console.log('Video can play through');
        hideLoadingSpinner();
    });

    // Also hide spinner when video starts playing
    player.on('playing', () => {
        console.log('Video is playing');
        hideLoadingSpinner();
    });

    // Auto-hide controls like YouTube
    let controlsTimeout;
    const showControls = () => {
        player.elements.container.classList.add('plyr--playing');
        clearTimeout(controlsTimeout);
        controlsTimeout = setTimeout(() => {
            if (player.playing && !player.paused) {
                player.elements.container.classList.remove('plyr--playing');
            }
        }, 3000);
    };

    player.on('play', showControls);
    player.on('pause', showControls);
    player.on('seeking', showControls);
    player.on('mousemove', showControls);

    console.log("Plyr video player initialized with YouTube-like features", player);

    return player;
}

document.addEventListener("turbo:load", () => {
    initializeVideoPlayer();
});

// Listen for turbo frame loads (when frames are replaced)
document.addEventListener("turbo:frame-load", () => {
    initializeVideoPlayer();
});

// Listen for turbo stream actions (alternative approach)
document.addEventListener("turbo:before-stream-render", () => {
    // Initialize player after a short delay to ensure DOM is updated
    setTimeout(() => {
        initializeVideoPlayer();
    }, 100);
});
