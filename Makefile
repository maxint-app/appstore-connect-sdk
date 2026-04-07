generate-sdk:
	oapi-codegen -config cfg.yaml ./openapi.oas.json

.PHONY: generate-sdk