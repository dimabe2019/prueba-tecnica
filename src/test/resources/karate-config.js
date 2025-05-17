function fn() {
    karate.configure('connectTimeout', 25000);
    karate.configure('readTimeout', 25000);
    karate.configure('ssl', true);
    karate.configure('logPrettyRequest', true);
    karate.configure('logPrettyResponse', true);

    return {
        api: {
            baseUrlNovedades: 'https://test-container-qa.prueba.co',
            baseUrlNovMock:'http://localhost:3000/test-container-qa.prueba.co'
        },
        path: {
            obtenerNovedades: '/v1/entity/novelties/'
        },
        test: {
            bucketName: 'test-automation-qa',
            folderRecaudoFiles: 'files-to-cash-in',
            cashInNovelty_status: "200"

        }
    };
}