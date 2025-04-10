from http.server import BaseHTTPRequestHandler, HTTPServer

class HelloHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Hello from Python server!")

if __name__ == "__main__":
    server = HTTPServer(('0.0.0.0', 8000), HelloHandler)
    print("Starting server on port http://0.0.0.0:8000")
    server.serve_forever()
