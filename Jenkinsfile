node {
    def app

    stage('Clone Code Repository') {

        checkout scm
    }

    stage('Build Image Main Repository') {

        app = docker.build("amnestor/aoe2detauntsbot")
    }


    stage('Push Image Main Repository') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }

    stage('Build Image Backup Repository') {

        app = docker.build("nvertoletik/aoe2detauntsbot")
    }


    stage('Push Image Backup Repository') {
        docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-nvertoletik') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }

    stage('Build Image Cloud Repository') {

        app = docker.build("gcr.io/ace-app-dev/ntt/aoe2detauntsbot")
    }


    stage('Push Image Cloud Repository') {
        docker.withRegistry('https://gcr.io/', 'gcp-registry-dev') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
    
    def remote = [:]
    remote.name = 'Master'
    remote.host = '192.168.1.173'
    remote.user = 'ubuntu'
    remote.password = 'raspberry'
    remote.allowAnyHosts = true
    
    stage('Pulling Changes To Local Repo'){ 
        sshCommand remote: remote, command: "git clone https://github.com/nestortechtips/aoe2detauntsbot.git"
    }
    
    stage('Updating Manifest') {
        sshCommand remote: remote, command: "sed -i -e \"s/TAG/${env.BUILD_NUMBER}/g\" /home/ubuntu/aoe2detauntsbot/manifests/00-aoe2tauntbot-deployment.yaml"
  }
    
    stage('Applying manifest'){
        sshCommand remote: remote, command: "kubectl apply -f /home/ubuntu/aoe2detauntsbot/manifests/00-aoe2tauntbot-deployment.yaml"
    }

    stage ('Adding reason of change to Kubernetes'){
        sshCommand remote: remote, command: "kubectl annotate deploy/aoe2detauntsbot -n aoe2bot kubernetes.io/change-cause=\"Update the service to version ${env.BUILD_NUMBER}\" --record=false --overwrite=true"
    }

    stage('Removing file'){
        sshCommand remote: remote, command: "rm -rf aoe2detauntsbot/"
    }
}
