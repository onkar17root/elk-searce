provider "google" {
    project = "searce-playground"
  
}


resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "asia-south1"
  remove_default_node_pool = true
  initial_node_count       = 1
  network    =  "onkar-179-vpc"
  subnetwork = "on17-public-subnet"
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "asia-south1"
  cluster    = google_container_cluster.primary.name
  node_count = 1  
  node_config {
    preemptible  = true
    machine_type = "e2-micro"
  }
}


data "google_container_cluster" "my_cluster" {
  name     = google_container_cluster.primary.name
  location =  google_container_cluster.primary.location
}

output "gke-k8s" {
  
  value = data.google_container_cluster.my_cluster
}

resource "null_resource" "kubeconfig1" {
  

provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region asia-south1 --project searce-playground"
  }

}