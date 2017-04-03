#!groovy
podTemplate(label: 'jnlp', containers: [
        containerTemplate(name: 'jnlp', image: 'henryrao/jnlp-slave', args: '${computer.jnlpmac} ${computer.name}', alwaysPullImage: true)
],
        volumes: [
          hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
        ]
) {
    properties([
            pipelineTriggers([]),
            parameters([
                    string(name: 'imageRepo', defaultValue: 'henryrao/jnlp-slave', description: 'Name of Image' )
            ]),
    ])

    node('jnlp') {
        withDockerRegistry([credentialsId: 'docker-login']) {
                docker.build(params.imageRepo,'.').push('latest')
				}
    }
}
