
# Create Event Hubs
variable "number_of_topics" {
  description = "Number of Kafka topics to create"
  type        = number
  default     = 3 # Specify how many topics you want. / X
}

variable "partitions_per_topic" {
  description = "Number of partitions per topic"
  type        = number
  default     = 4 # Specify the number of partitions for each topic.
}
