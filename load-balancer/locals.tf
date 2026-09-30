locals {
  backend_instance_group = (
    data.tfe_outputs.mig
    .nonsensitive_values
    .instance_group
  )
}
