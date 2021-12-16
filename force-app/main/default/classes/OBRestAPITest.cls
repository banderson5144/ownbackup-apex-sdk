@isTest
public with sharing class OBRestAPITest
{
    private static void setMocks(map<String,String> mocks)
    {
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();

        multimock.setStaticResource('callout:OB_REST_API/auth/v1/login', 'mockOBAuthResp');

        if(mocks != null)
        {
            for(String k : mocks.keySet())
            {
                multimock.setStaticResource(mocks.get(k),k);
            }
        }

        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multimock);
    }

    @isTest
    private static void testOBAuthCall()
    {
        // Test data setup
        setMocks(null);
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
    
        Test.stopTest();
    
        // Asserts
        System.assertEquals('12345', ob.ObSessionId);
    }

    @isTest
    private static void testOBGetAllServices()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBAllServicesResp' => 'callout:OB_REST_API/v1/services'});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        OBRestAPI.OBServicesResp[] res = ob.getAllServices();
    
        Test.stopTest();
    
        // Asserts
        System.assertEquals(10, res[0].num_items);
    }

    @isTest
    private static void testOBGetServiceById()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBServicesByIdResp' => 'callout:OB_REST_API/v1/services/12345'});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        OBRestAPI.OBServicesResp res = ob.getServiceById('12345');
    
        Test.stopTest();
    
        // Asserts
        System.assertEquals(10, res.num_items);
    }

    @isTest
    private static void testOBBackupServiceNow()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBEmptyResponse' => 'callout:OB_REST_API/v1/services/12345/backup_now'});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        ob.backupServiceNow('12345');
    
        Test.stopTest();
    }

    @isTest
    private static void testOBBackupSpecificObjs()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBEmptyResponse' => 'callout:OB_REST_API/v1/services/12345/backup_specific_objects_now'});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        ob.backupSpecificObjs('12345',new String[]{'Account','Contact'});
    
        Test.stopTest();
    }

    @isTest
    private static void testOBGetBackupsByServiceId()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBBackupsByServiceIdResp' => 'callout:OB_REST_API/v1/services/12345/backups'});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        OBRestAPI.OBBackupResp[] res = ob.getBackupsByServiceId('12345');
    
        Test.stopTest();

        // Asserts
        System.assertEquals(123, res[0].num_api_calls);
    }

    @isTest
    private static void testOBGetBackupById()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBBackupByIdResp' => 'callout:OB_REST_API/v1/services/12345/backups/12345'});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        OBRestAPI.OBBackupResp res = ob.getBackupById('12345','12345');
    
        Test.stopTest();

        // Asserts
        System.assertEquals(123, res.num_api_calls);
    }

    @isTest
    private static void testOBGetObjsInBkup()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBGetObjsInBackupResp' => 'callout:OB_REST_API/v1/services/12345/backups/12345/objects'});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        OBRestAPI.OBBackupObjResp[] res = ob.getObjsInBkup('12345','12345');
    
        Test.stopTest();

        // Asserts
        System.assertEquals(123, res[0].num_deleted_items);
    }

    @isTest
    private static void testOBGetListOfJobs()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBListOfJobsResp' => 'callout:OB_REST_API/v1/jobs'});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        OBRestAPI.OBJobResp[] res = ob.getListOfJobs();
    
        Test.stopTest();

        // Asserts
        System.assertEquals(100, res[0].progress);
    }

    @isTest
    private static void testOBJobById()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBJobByIdResp' => 'callout:OB_REST_API/v1/jobs/12345'});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        OBRestAPI.OBJobResp res = ob.getJobById('12345');
    
        Test.stopTest();

        // Asserts
        System.assertEquals(100, res.progress);
    }

    @isTest
    private static void testOBGetEvents()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBGetEventsResp' => 'callout:OB_REST_API/v1/events?from='});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        OBRestAPI.OBEventResp[] res = ob.getEvents(null);
    
        Test.stopTest();

        // Asserts
        System.assertEquals('123.45.67.89', res[0].ip_address);
    }

    @isTest
    private static void testOBGetAllESBSServices()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBESBSServicesResp' => 'callout:OB_REST_API/v1/sbs/services'});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        OBRestAPI.OBESBSServiceResp[] res = ob.getAllESBSServices();
    
        Test.stopTest();

        // Asserts
        System.assertEquals(12345, res[0].id);
    }

    @isTest
    private static void testOBGetAllESBSTemplates()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBESBSTemplatesResp' => 'callout:OB_REST_API/v1/sbs/templates'});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        OBRestAPI.OBESBSTemplateResp[] res = ob.getAllESBSTemplates();
    
        Test.stopTest();

        // Asserts
        System.assertEquals(12345, res[0].id);
    }

    @isTest
    private static void testOBGetESBSServiceAutomations()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBESBSAutomationsResp' => 'callout:OB_REST_API/v1/sbs/services/12345/automations'});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        OBRestAPI.OBESBSServiceAutomationResp res = ob.getESBSServiceAutomations('12345');
    
        Test.stopTest();

        // Asserts
        System.assertEquals('fooTrigger', res.ApexTrigger[0]);
    }

    @isTest
    private static void testOBSubmitGDRPRectifyReq()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBGDPRResp' => 'callout:OB_REST_API/v1/services/12345/gdpr/rectify'});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        OBRestAPI.OBGDPRReq req = new OBRestAPI.OBGDPRReq();
        OBRestAPI.OBGDPRResp res = ob.submitGDRPRectifyReq('12345', req);
    
        Test.stopTest();

        // Asserts
        System.assertEquals(12345, res.id);
    }

    @isTest
    private static void testOBSubmitGDRPForgetReq()
    {
        // Test data setup
        setMocks(new map<String,String>{'mockOBGDPRResp' => 'callout:OB_REST_API/v1/services/12345/gdpr/forget'});
    
        // Actual test
        Test.startTest();

        OBRestAPI ob = new OBRestAPI();
        OBRestAPI.OBGDPRReq req = new OBRestAPI.OBGDPRReq();
        OBRestAPI.OBGDPRResp res = ob.submitGDRPForgetReq('12345', req);
    
        Test.stopTest();

        // Asserts
        System.assertEquals(12345, res.id);
    }
}