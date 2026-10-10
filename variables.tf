variable "appconfig_configuration_profiles" {
  description = <<EOT
Map of appconfig_configuration_profiles, attributes below
Required:
    - application_id
    - location_uri
    - name
Optional:
    - description
    - kms_key_identifier
    - region
    - retrieval_role_arn
    - tags
    - tags_all
    - type
    - validator (block):
        - content (optional)
        - type (required)
EOT

  type = map(object({
    application_id     = string
    location_uri       = string
    name               = string
    description        = optional(string)
    kms_key_identifier = optional(string)
    region             = optional(string)
    retrieval_role_arn = optional(string)
    tags               = optional(map(string))
    tags_all           = optional(map(string))
    type               = optional(string)
    validator = optional(list(object({
      content = optional(string)
      type    = string
    })))
  }))
  validation {
    condition = alltrue([
      for k, v in var.appconfig_configuration_profiles : (
        v.validator == null || (length(v.validator) <= 2)
      )
    ])
    error_message = "Each validator list must contain at most 2 items"
  }
  validation {
    condition = alltrue([
      for k, v in var.appconfig_configuration_profiles : (
        length(v.location_uri) >= 1 && length(v.location_uri) <= 2048
      )
    ])
    error_message = "must be between 1 and 2048 characters"
  }
  # Note: 8 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

