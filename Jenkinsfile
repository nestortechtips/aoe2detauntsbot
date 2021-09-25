node {
    def app

    stage('[ARM64]Clone Code Repository') {

        checkout scm
    }

    stage('[ARM64]Build Image Main Repository') {

        app = docker.build("amnestor/aoe2detauntsbot")
    }


    stage('[ARM64]Push Image Main Repository') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }

    stage('[ARM64]Build Image Backup Repository') {

        app = docker.build("nvertoletik/aoe2detauntsbot")
    }


    stage('[ARM64]Push Image Backup Repository') {
        docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-nvertoletik') {
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
        sshCommand remote: remote, command: "sed -i -e \"s/TAG/${env.BUILD_NUMBER}/g\" \$GCP_BUILD_PATH/aoe2detauntsbot/manifests/10-aoe2tauntbot-deployment.yaml"
        sshCommand remote: remote, command: "sed -i -e \"s/TAG/${env.BUILD_NUMBER}/g\" \$GCP_BUILD_PATH/aoe2detauntsbot/cb.yaml"
  }

    stage('[AMD64/ARM64]Building images in Cloud Build'){ 
        sshCommand remote: remote, command: "gcloud builds submit --config $GCP_BUILD_PATH/aoe2detauntsbot/cb.yaml"
    }
    
    stage('Applying manifest'){
        sshCommand remote: remote, command: "kubectl apply -f $GCP_BUILD_PATH/aoe2detauntsbot/manifests/"
    }

    stage ('Adding reason of change to Kubernetes'){
        sshCommand remote: remote, command: 'cd $GCP_BUILD_PATH/aoe2detauntsbot; kubectl annotate deploy/aoe2detauntsbot -n aoe2bot kubernetes.io/change-cause=\"$(git log -1 --pretty=format:"%s")\" --record=false --overwrite=true'
    }

    stage('Removing file'){
        sshCommand remote: remote, command: "rm -rf $GCP_BUILD_PATH/aoe2detauntsbot/"
    }
}
