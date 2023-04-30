browser.runtime.sendMessage({ greeting: "hello" }).then((response) => {
    console.log("Received response: ", response);
});

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log("Received request: ", request);
});


// Listen for the load event to check the initial URL
window.addEventListener('load', function() {
    checkUrl(window.location.href);
});

// Listen for the popstate event to check for URL changes
window.addEventListener('popstate', function() {
    checkUrl(window.location.href);
});

function checkUrl(url) {
    // If the URL is example.eth, replace the page content
    if (url === 'http://example.com/' || url === 'https://example.com/') {
        replaceContent();
    }
}

function replaceContent() {
    document.documentElement.innerHTML = `
        <!DOCTYPE html>
        <html lang="en">
            <head>
                <meta charset="UTF-8">
                <title>Page Title</title>
            </head>
            <body>
                Hello World
            </body>
        </html>
    `;
}


//// Listen for messages from the native app
//safari.self.addEventListener('message', function(event) {
//    if (event.name === 'response' && event.message === 'Hello world') {
//        // Display 'Hello world' as an alert
//        alert('Hello world');
//    }
//});
