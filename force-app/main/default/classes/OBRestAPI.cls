public with sharing class OBRestAPI
{
    @TestVisible
    private String ObSessionId;

    public OBRestAPI()
    {
        authorize();
    }

    public class OBAuthResp
    {
        public String session_id;
    }

    public class OBServicesResp
    {
        public Integer archived;
        public String displayed_name;
        public Integer enabled;
        public Integer id;
        public String last_backup;
        public Integer num_items;
        public String org_id;
        public String provider;
        public Integer return_code;
        public String return_message;
        public String secondary_name;
        public String status;
        public String subtitle;
        public Integer total_size;
    }

    public class OBBackupResp
    {
        public Integer num_sections_error;
        public Integer num_sections;
        public Integer num_sections_info;
        public Integer num_inserted_items;
        public Integer num_sections_ok;
        public Integer num_deleted_items;
        public Integer num_sections_warning;
        public Integer num_bulk_api_batches;
        public Integer num_updated_items;
        public Integer num_api_calls;
        public String status;
        public Integer id;
        public String trigger_type;
        public String completed_at;
    }

    public class OBBackupObjResp
    {
        public String name;
        public Integer num_api_calls;
        public String message;
        public Integer num_deleted_items;
        public Integer id;
        public Integer num_inserted_items;
        public String download_removed_link;
        public Integer num_items;
        public String download_link;
        public Integer num_updated_items;
        public String download_changed_link;
        public String status;
        public String download_added_link;
    }

    public class OBJobResp
    {
        public String status;
        public Integer progress;
        public String title;
        public Integer id;
    }

    public class OBGDPRReq
    {
        public String recordId;
        public String tableName;
        public String field;
        public String value;
        public String comment;

        public string formatData()
        {
            return 'record_id='+this.recordId+
                    '&table_name='+this.tableName+
                    '&field='+this.field+
                    '&value='+this.value+
                    '&comment='+this.comment;
        }
    }

    public class OBEventResp
    {
        public Integer service_id;
        public String key;
        public String source;
        public String ip_address;
        public String user_email;
        public Integer event_id;
        public Integer user_id;
        public String created_at;
    }

    public class OBESBSServiceResp
    {
        public String type;
        public Boolean indexed;
        public Integer id;
        public Boolean allowed_as_a_destination;
        public String suffix;
        public String name;
    }

    public class OBESBSTemplateResp
    {
        public Boolean source_service_available;
        public String source_service_name;
        public Boolean is_locked;
        public String anonymization_template_id;
        public Boolean is_draft;
        public Integer source_service_id;
        public String editor_email;
        public String description;
        public String destination_size;
        public String name;
        public String latest_seed_date;
        public String template_type;
        public Boolean is_favorite;
        public Integer id;
    }

    public class OBESBSServiceAutomationResp
    {
        public String[] ValidationRule;
        public String[] ApexTrigger;
        public String[] FlowDefinition;
    }

    public class OBGDPRResp
    {
        public Integer id;
    }

    /**
    * @description Authenticate a user by email and password.
    */
    private void authorize()
    {
        String body = 'email={!HTMLENCODE($Credential.Username)}&password={!HTMLENCODE($Credential.Password)}';
        map<String,String> headers = new map<String,String>{'Content-Type'=>'application/x-www-form-urlencoded'};
        String jsonStr = baseHttp('/auth/v1/login', 'POST', headers, body);
        OBAuthResp res = (OBAuthResp)JSON.deserialize(jsonStr, OBRestAPI.OBAuthResp.class);
        this.ObSessionId = res.session_id;
    }

    /**
    * @description Get a list of all services.
    * @return Returns list of all services.
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * OBRestAPI.OBServicesResp[] res = ob.getAllServices();
    */
    public OBServicesResp[] getAllServices()
    {
        String jsonStr = baseHttp('/v1/services', 'GET', null, null);
        OBServicesResp[] res = (OBServicesResp[])JSON.deserialize(jsonStr, List<OBRestAPI.OBServicesResp>.class);
        return res;
    }

    /**
    * @description Get a specific service by Service id.
    * @param serviceId Id of the service
    * @return Returns a single service.
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * OBRestAPI.OBServicesResp res = ob.getServiceById('12345');
    */
    public OBServicesResp getServiceById(String serviceId)
    {
        String jsonStr = baseHttp('/v1/services/'+serviceId, 'GET', null, null);
        OBServicesResp res = (OBServicesResp)JSON.deserialize(jsonStr, OBRestAPI.OBServicesResp.class);
        return res;
    }

    /**
    * @description Start backup a service manually now by Service id.
    * @param serviceId Id of the service
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * ob.backupServiceNow('12345');
    */
    public void backupServiceNow(String serviceId)
    {
        String jsonStr = baseHttp('/v1/services/'+serviceId+'/backup_now', 'POST', null, null);
    }

    /**
    * @description Start a backup for specific objects manually now by Service id.
    * @param serviceId Id of the service
    * @param lstOfObjs List of objects
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * ob.backupSpecificObjs('12345',new String[]{'Account','Contact'});
    */
    public void backupSpecificObjs(String serviceId, String[] lstOfObjs)
    {
        String[] bodyArr = new String[]{};

        for(String sObj : lstOfObjs)
        {
            bodyArr.add('list_of_objects='+sObj);
        }
        
        String jsonStr = baseHttp('/v1/services/'+serviceId+'/backup_specific_objects_now', 'POST', null, String.join(bodyArr,'&'));
    }

    /**
    * @description Get a list of all available backups for a given service.
    * @param serviceId Id of the service
    * @return List of Backup responses
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * OBRestAPI.OBBackupResp[] res = ob.getBackupsByServiceId('12345');
    */
    public OBBackupResp[] getBackupsByServiceId(String serviceId)
    {
        String jsonStr = baseHttp('/v1/services/'+serviceId+'/backups', 'GET', null, null);
        OBBackupResp[] res = (OBBackupResp[])JSON.deserialize(jsonStr, List<OBRestAPI.OBBackupResp>.class);
        return res;
    }

    /**
    * @description Get a specific backup by the Service id and Backup id. Parameter backup_id can be 'last'
    * @param serviceId Id of the service
    * @param backupId Id of the backup
    * @return Single instance of a Backup responses
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * OBRestAPI.OBBackupResp res = ob.getBackupById('12345','12345');
    */
    public OBBackupResp getBackupById(String serviceId, String backupId)
    {
        String jsonStr = baseHttp('/v1/services/'+serviceId+'/backups/'+backupId, 'GET', null, null);
        OBBackupResp res = (OBBackupResp)JSON.deserialize(jsonStr, OBRestAPI.OBBackupResp.class);
        return res;
    }

    /**
    * @description Get list of objects in a backup by Service id and Backup id. Parameter backup_id can be 'last'.
    * @param serviceId Id of the service
    * @param backupId Id of the backup
    * @return List of objecst in a backup
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * OBRestAPI.OBBackupObjResp[] res = ob.getObjsInBkup('12345','12345');
    */
    public OBBackupObjResp[] getObjsInBkup(String serviceId, String backupId)
    {
        String jsonStr = baseHttp('/v1/services/'+serviceId+'/backups/'+backupId+'/objects', 'GET', null, null);
        OBBackupObjResp[] res = (OBBackupObjResp[])JSON.deserialize(jsonStr, List<OBRestAPI.OBBackupObjResp>.class);
        return res;
    }

    /**
    * @description Get a list of all jobs.
    * @return List of jobs
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * OBRestAPI.OBJobResp[] res = ob.getListOfJobs();
    */
    public OBJobResp[] getListOfJobs()
    {
        String jsonStr = baseHttp('/v1/jobs', 'GET', null, null);
        OBJobResp[] res = (OBJobResp[])JSON.deserialize(jsonStr, List<OBRestAPI.OBJobResp>.class);
        return res;
    }

    /**
    * @description Get specific job by Id.
    * @param jobId Id of the job
    * @return Single instance of job
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * OBRestAPI.OBJobResp res = ob.getJobById('12345');
    */
    public OBJobResp getJobById(String jobId)
    {
        String jsonStr = baseHttp('/v1/jobs/'+jobId, 'GET', null, null);
        OBJobResp res = (OBJobResp)JSON.deserialize(jsonStr, OBRestAPI.OBJobResp.class);
        return res;
    }

    /**
    * @description submitting a GDPR rectify request.
    * @param jobId Id of the job
    * @param req GDPR Request data
    * @return Single instance of job
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * OBRestAPI.OBGDPRReq req = new OBRestAPI.OBGDPRReq();
    * req.recordId = '00x000000000000000';
    * req.tableName = 'Custom_Object__c';
    * req.field = 'foo__c';
    * req.value = 'bar';
    * req.comment = 'Some comments';
    * OBRestAPI.OBGDPRResp res = ob.submitGDRPRectifyReq('12345', req);
    */
    public OBGDPRResp submitGDRPRectifyReq(String serviceId, OBGDPRReq req)
    {
        map<String,String> headers = new map<String,String>{'Content-Type'=>'application/x-www-form-urlencoded'};
        String jsonStr = baseHttp('/v1/services/'+serviceId+'/gdpr/rectify', 'POST', headers, req.formatData());
        OBGDPRResp res = (OBGDPRResp)JSON.deserialize(jsonStr, OBRestAPI.OBGDPRResp.class);
        return res;
    }

    /**
    * @description submitting a GDPR forget request.
    * @param jobId Id of the job
    * @param req GDPR Request data
    * @return Single instance of job
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * OBRestAPI.OBGDPRReq req = new OBRestAPI.OBGDPRReq();
    * req.recordId = '00x000000000000000';
    * req.tableName = 'Custom_Object__c';
    * req.comment = 'Some comments';
    * OBRestAPI.OBGDPRResp res = ob.submitGDRPForgetReq('12345', req);
    */
    public OBGDPRResp submitGDRPForgetReq(String serviceId, OBGDPRReq req)
    {
        map<String,String> headers = new map<String,String>{'Content-Type'=>'application/x-www-form-urlencoded'};
        String jsonStr = baseHttp('/v1/services/'+serviceId+'/gdpr/forget', 'POST', headers, req.formatData());
        OBGDPRResp res = (OBGDPRResp)JSON.deserialize(jsonStr, OBRestAPI.OBGDPRResp.class);
        return res;
    }

    /**
    * @description Get the account event history from the beginning of time (default route) or all events that follows a specific event (use parameter with the id of an event), results are limited to 1,000 events per request.
    * @param eventId Id of the event
    * @return List of events
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * OBRestAPI.OBEventResp[] res = ob.getEvents('12345');
    */
    public OBEventResp[] getEvents(String eventId)
    {
        String jsonStr = baseHttp('/v1/events?from='+(eventId!=null?eventId:''), 'GET', null, null);
        OBEventResp[] res = (OBEventResp[])JSON.deserialize(jsonStr, List<OBRestAPI.OBEventResp>.class);
        return res;
    }

    /**
    * @description Get all services that can be used as destination for seeds.
    * @return List of ESBS Services
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * OBRestAPI.OBESBSServiceResp[] res = ob.getAllESBSServices();
    */
    public OBESBSServiceResp[] getAllESBSServices()
    {
        String jsonStr = baseHttp('/v1/sbs/services', 'GET', null, null);
        OBESBSServiceResp[] res = (OBESBSServiceResp[])JSON.deserialize(jsonStr, List<OBRestAPI.OBESBSServiceResp>.class);
        return res;
    }

    /**
    * @description Get all seeding templates that the user has access to.
    * @return List of ESBS Templates
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * OBRestAPI.OBESBSTemplateResp[] res = ob.getAllESBSTemplates();
    */
    public OBESBSTemplateResp[] getAllESBSTemplates()
    {
        String jsonStr = baseHttp('/v1/sbs/templates', 'GET', null, null);
        OBESBSTemplateResp[] res = (OBESBSTemplateResp[])JSON.deserialize(jsonStr, List<OBRestAPI.OBESBSTemplateResp>.class);
        return res;    
    }

    /**
    * @description Get active automations names by automation type, of the specified service (excluding automations from managed packages, since they cannot be disabled by salesforce).
    * @param serviceId Id of service
    * @return List of SF automations of service
    * @example
    * OBRestAPI ob = new OBRestAPI();
    * OBRestAPI.OBESBSServiceAutomationResp res = ob.getESBSServiceAutomations('12345');
    */
    public OBESBSServiceAutomationResp getESBSServiceAutomations(String serviceId)
    {
        String jsonStr = baseHttp('/v1/sbs/services/'+serviceId+'/automations', 'GET', null, null);
        OBESBSServiceAutomationResp res = (OBESBSServiceAutomationResp)JSON.deserialize(jsonStr, OBRestAPI.OBESBSServiceAutomationResp.class);
        return res;
    }

    /**
    * @description Base HTTP call for all API calls
    * @param path URL Path for API call
    * @param method HTTP Method used for API call
    * @param headers any extra HTTP headers needed for API call
    * @param body any data that needs to be sent
    * @return Body response from API call
    * @example
    * String body = 'email={!$Credential.Username}&password={!$Credential.Password}';
    * map<String,String> headers = new map<String,String>{'Content-Type'=>'application/x-www-form-urlencoded'};
    * String jsonStr = baseHttp('/auth/v1/login', 'POST', headers, body);
    */
    private String baseHttp(String path, String method, map<String,String> headers, String body)
    {
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('callout:OB_REST_API'+path);
        request.setMethod(method);
        request.setHeader('Accept','*/*');
        
        if(headers != null)
        {
            for(String key : headers.keySet())
            {
                request.setHeader(key,headers.get(key));
            }
        }

        if(body != null)
        {
            request.setBody(body);
        }

        if(this.ObSessionId != null)
        {
            request.setHeader('X-SESSION-ID',this.ObSessionId);
        }
        
        Http httpObject = new Http();
        HttpResponse response = httpObject.send(request);
        return response.getBody();
    }
}
