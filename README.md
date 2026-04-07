# AppStore Connect API SDK

Go SDK for the Apple App Store Connect API, generated from the App Store Connect OpenAPI schema (version 4.3).

This package provides typed request/response models and a generated HTTP client for App Store Connect endpoints across API versions (v1/v2/v3).

## Important Links

- Apple App Store Connect API overview: https://developer.apple.com/documentation/appstoreconnectapi
- Apple authentication for App Store Connect API (JWT): https://developer.apple.com/documentation/appstoreconnectapi/generating-tokens-for-api-requests
- App Store Connect API release notes: https://developer.apple.com/documentation/appstoreconnectapi/app-store-connect-api-release-notes

## Installation

```bash
go get github.com/maxint-apps/appstore-connect-sdk
```

Import:

```go
import appstore_connect_sdk "github.com/maxint-apps/appstore-connect-sdk"
```

## Authentication

App Store Connect API uses a Bearer token (JWT) signed with ES256.

This SDK does not generate JWT tokens for you; provide a token via a request editor:

```go
func bearerTokenEditor(token string) appstore_connect_sdk.RequestEditorFn {
	return func(ctx context.Context, req *http.Request) error {
		req.Header.Set("Authorization", "Bearer "+token)
		return nil
	}
}
```

See Apple docs for JWT details and required claims.

## Quick Start

The default server URL from the schema is:

https://api.appstoreconnect.apple.com/

Create a typed client and call an endpoint:

```go
package main

import (
	"context"
	"fmt"
	"log"
	"net/http"

	appstore_connect_sdk "github.com/maxint-apps/appstore-connect-sdk"
)

func bearerTokenEditor(token string) appstore_connect_sdk.RequestEditorFn {
	return func(ctx context.Context, req *http.Request) error {
		req.Header.Set("Authorization", "Bearer "+token)
		return nil
	}
}

func main() {
	token := "<YOUR_APP_STORE_CONNECT_JWT>"

	client, err := appstore_connect_sdk.NewClientWithResponses(
		"https://api.appstoreconnect.apple.com",
		appstore_connect_sdk.WithRequestEditorFn(bearerTokenEditor(token)),
	)
	if err != nil {
		log.Fatalf("create client: %v", err)
	}

	resp, err := client.AppsGetCollectionWithResponse(context.Background(), nil)
	if err != nil {
		log.Fatalf("apps get collection: %v", err)
	}

	if resp.JSON200 != nil {
		fmt.Printf("fetched %d app(s)\n", len(resp.JSON200.Data))
		return
	}

	if resp.JSON401 != nil {
		log.Fatalf("unauthorized: check JWT generation and expiration")
	}

	log.Fatalf("unexpected status: %s", resp.HTTPResponse.Status)
}
```

## Raw Client Option

You can also use the non-typed client (`NewClient`) if you want raw `*http.Response` handling.

## Regenerating the SDK

This repository includes generation config in [cfg.yaml](cfg.yaml).

Generate with Make:

```bash
make generate-sdk
```

Equivalent command:

```bash
oapi-codegen -config cfg.yaml ./openapi.oas.json
```

If needed, install oapi-codegen first:

```bash
go install github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen@latest
```

## License

This project is intended to use the Mozilla Public License 2.0 (MPL-2.0).

<p align="center">
© Maxint Inc. 2026
</p>