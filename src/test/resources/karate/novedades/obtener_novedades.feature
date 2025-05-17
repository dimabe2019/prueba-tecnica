Feature: sample karate test script

  Background:
    * configure retry = {count: 3, interval: 3000}
    * url api.baseUrlNovMock
    * def uuid = function(){return java.util.UUID.randomUUID() + ""}
    * def noveltyUuid = uuid()
    * def cabeceras = read("../../jsonbase/headers/novedadesHeaders.json")
    * path path.obtenerNovedades + noveltyUuid
    * def path2 =  '/novelty-details'
    * def S3Manager = Java.type("karate.utils.S3Util")
    * def S3ManagerInstance = new S3Manager()
    * def SQSManager = karate.callSingle('classpath:data/instances-sqs.js')
    * def FileUtils = Java.type("karate.utils.FileUtils")
    * def CsvEditorUtil = Java.type("karate.utils.CSVModificar")
    * def recaudoUtils = Java.type("karate.utils.RecaudoUtils")

    @regression
    Scenario Outline: Procesamiento exitoso de recaudo
    * def bucketName = test.bucketName
    * def folderRecaudoFiles = test.folderRecaudoFiles
    * print "El uuid de la novedad es: " + noveltyUuid
    * def fileExtension = ".csv"
    * def fullFileName = noveltyUuid + fileExtension
      * print SQSManager

    # Modifica el archivo .csv
    * def result = CsvEditorUtil.modifyDueDate('classpath:data/recaudoTemplateDatosCorrectos.csv' , '2024-04-20')
    * match result == true

    # Renombrar archivo
    * def renombrar = FileUtils.renameFile(currentFilePath, currentFileName, newPathNewFile, noveltyUuid, fileExtension)
      * print "El resultado de renombrar el archivo es: " + renameFile
      * match renameFile == true

      # Subir a S3
      * print "El bucket es: " + bucketName
      * print "El folder  es: " + folderRecaudoFiles
      * S3ManagerInstance.uploadFileToBucket(bucketName, folderRecaudoFiles, fullFileName, newPathNewFile)


      # Espearar que archivo aparezca en S3 (espera activa, sin sleep)
      * retry until S3ManagerInstance.doesFileExist(bucketName, folderRecaudoFiles, fullFileName)
      * def fileExist = S3ManagerInstance.doesFileExist(bucketName, folderRecaudoFiles, fullFileName)
      * print "La existencia del archivo es: " + fileExist
      * match fileExist == true

      # Envar mensaje a la cola
      * def variableMapToReplaceInQueueMessageBody =
        """
        {
          "fileName": '#(fullFileName)',
          "workplacebankCode": cabeceras,
          "bucketName": '#(bucketName)'
        }
        """
      * SQSManager.sendMessageToQueue('<jsonFileSqsEvents>', 'testing-recaudo-qa.fifo', variableMapToReplaceInQueueMessageBody, '<pathJsonFileSqsEvents>')

      #Esperar que el sistema procese el mensaje
      * retry until recaudoUtils.isFileProcessed(novelty)

      Examples:
      |jsonFileSqsEvents|pathJsonFileSqsEvents   |
      |queueEvent.json  |../../jsonbase/response/|

    @NovedadSuccess
    Scenario Outline: obtener informacion de las novedades exitosamente
      Given headers cabeceras
      And retry until responseStatus == 200 && test.cashInNovelty_status == responseStatus
      When method get
      Then status 200
      * def respuesta = response
      * def totalAmount = respuesta.map(x => parseFloat(x.cashInInfo.amount) ).reduce((a,b) => a + b, 0)
      #* print 'Total Amount: ', totalAmount
      * def cashInNoveltyDetailsCounterstotal = respuesta.filter(x => x.payerInfo).length
      * match totalAmount == <expectedTotal>
      * match respuesta..status contains '<noveltyStatus>'
      * match cashInNoveltyDetailsCounterstotal == <registerTotal>
      * match respuesta..cashInInfo.description contains <validationErrorNumber>

      Examples:
        |clientCode|expectedTotal|noveltyStatus|registerTotal | validationErrorNumber |jsonDataWithExpectedInformation      |
        |TEST01    |1004999.0    | CREATED     | 3            | null                  |respuestaEsperadaDatosCorrectos.json |


    # Validar API de novelty-details
    @DetalleNovedad
    Scenario Outline: obtener informacion de detalle novedades
      * def dataWithExpectedInformation = karate.read("classpath:jsonbase/response/" + '<jsonDataWithExpectedInformation>')
      Given headers cabeceras
      And path path2
      And params { size: <size>, page: <page> }
      And retry until responseStatus == 200 && response.content != []
      When method GET
      Then status 200
      * match response contains only deep dataWithExpectedInformation

    Examples:
     |jsonDataWithExpectedInformation            |page|size|
     |respuestaEsperadaCaracteresEspeciales.json |1   |2   |









