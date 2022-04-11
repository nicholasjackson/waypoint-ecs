package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(rw http.ResponseWriter, r *http.Request) {
		fmt.Fprint(rw, "Hello World v7")
	})

	http.ListenAndServe(":3000", nil)
}
