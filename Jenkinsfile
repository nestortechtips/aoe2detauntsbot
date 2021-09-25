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
    
    stage('Running Build Script'){ 
        sshCommand remote: remote, command: "cd aoe2detauntsbot/run;./build.sh ${env.BUILD_NUMBER}"
    }
}
