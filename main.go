package main

import (
	"net/http"
	"os"
)

func main() {
	http.Handle("/", http.StripPrefix("/", http.FileServer(http.Dir("./docs"))))
	http.ListenAndServe(":"+os.Getenv("PORT"), nil)
}
