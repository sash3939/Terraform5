variable "low_string" {
  type        = string
  description = "любая строка"
  default = "stringUP"
  validation {
    condition     = can(regex("^[^A-Z]*$", var.low_string))
    error_message = "only lower case"
  }
}

variable "in_the_end_there_can_be_only_one" {
    description="Who is better Connor or Duncan?"
    type = object({
        Dunkan = optional(bool)
        Connor = optional(bool)
    })
    default = {
        Dunkan = true
        Connor = true
    }
    validation {
      condition = (var.in_the_end_there_can_be_only_one.Dunkan != true && var.in_the_end_there_can_be_only_one.Connor != false) || (var.in_the_end_there_can_be_only_one.Dunkan != false && var.in_the_end_there_can_be_only_one.Connor != true)
      error_message = "There can be only one MacLeod"
    }
}
