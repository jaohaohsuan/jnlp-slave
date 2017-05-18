#!groovy
podTemplate(
    label     : 'jnlp', 
    containers: [ containerTemplate(name: 'jnlp', image: 'henryrao/jnlp-slave', args: '${computer.jnlpmac} ${computer.name}', alwaysPullImage: true) ],
    volumes   : [ hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock') ]
) {
    node('jnlp') {
        stage('checkout') {
            checkout scm
        }
        
        // def imgSha = sh(returnStdout: true, script: "docker build --pull -q .").trim()[7..-1]
        def head = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
        def image

        stage('build') {
           image = docker.build("henryrao/henryrao/jnlp-slave", "--no-cache=true --pull .")
        }
        
        stage('push') {
            docker.withRegistry('https://registry.hub.docker.com/', 'docker-login') {
                image.push("$head")
                image.push('latest')
            }
        }
    }
}