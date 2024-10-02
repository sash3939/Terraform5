variable "ip_address_check" {
  type        = string
  default = "192.168.0.2222"
  description = "ip-адрес"
  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.ip_address_check))
    error_message = "need true ip-address"
  }
}

variable "ip_addresses" {
  type        = list(string)
  description = "Список IP-адресов"
  default     = ["1.1.1.1","1241.12.3.2"]
  validation {
    condition     = alltrue([for ip in var.ip_addresses: can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", ip))])
    error_message = "need correct ip-address"
  }
}
