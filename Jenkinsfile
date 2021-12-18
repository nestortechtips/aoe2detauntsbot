node {
    def remoteArm64 = [:]
    remoteArm64.name = 'raspberry-master1'
    remoteArm64.host = '192.168.1.173'
    remoteArm64.user = 'ubuntu'
    remoteArm64.password = 'raspberry'
    remoteArm64.allowAnyHosts = true
    
    
    stage('[ARM64|AMD64] Pulling Changes To Local Repo'){ 
        sshCommand remote: remoteArm64, command: "git clone https://github.com/nestortechtips/aoe2detauntsbot.git"
    }

    stage('[ARM64|AMD64] Running Build Script'){ 
        sshCommand remote: remoteArm64, command: "cd aoe2detauntsbot/run;./build.sh ${env.BUILD_NUMBER}"
    }
    
    def app

    stage('[ARM64]Clone Code Repository') {

        checkout scm
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

}