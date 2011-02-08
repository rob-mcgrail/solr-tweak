class Request
  # Request objects are placed in queries, where they create the
  # Solr request url.
  #
  # They are intended to be dropped in to queries, prepopulated with boosts
  # and other options, possibly via request#seed
  
  # q=test&   
  # qt=tki&                  :http://wiki.apache.org/solr/SolrRequestHandler
  # hl.usePhraseHighlighter=true
  # &hl.highlightMultiTerm=true
  # &start=0
  # &rows=10
  # &sort=score+desc
  # &indent=on&version=2.2&
  # bq=&    ?   bq what? ------> now done server side     Probably in a request handler called 'tki'
  # fl=&
  # fq=%27%21%28englishstatus%3ARejected%29%27
  # &hl=true
  # &hl.fl=attr_author_t+attr_blurb_t+attr_body_t+attr_caption_t+attr_category_t+attr_code_t+attr_commonname_t+attr_description_t+attr_duration_t+attr_email_t+attr_feature_block_t+attr_find_out_more_t+attr_first_name_t+attr_id_t+attr_image_t+attr_institution_name_t+attr_intro_t+attr_last_name_t+attr_level_t+attr_message2_t+attr_message_t+attr_moe_number_t+attr_name_t+attr_organisation_t+attr_pods_t+attr_principals_name_t+attr_region_map_html_t+attr_regsourceid_t+attr_school_name_t+attr_short_title_t+attr_signature_t+attr_subject_t+attr_success_message_t+attr_tags_lk+attr_title_t+attr_transcript_t+attr_uid_t+attr_url_t+attr_user_account_t+attr_usertrustlevel_t+attr_welcome_t+ezf_df_text
  # &hl.snippets=1
  # &hl.fragsize=200
  # &hl.requireFieldMatch=false
  # &hl.simple.pre=%3Cb%3E
  # &hl.simple.post=%3C%2Fb%3E
  # &wt=php                                     query response writer :http://wiki.apache.org/solr/QueryResponseWriter
  # &facet.field=meta_contentclass_id_si        :http://wiki.apache.org/solr/SimpleFacetParameters
  # &facet.field=meta_owner_id_si
  # &facet.field=attr_tags_lk
  # &facet.limit=5
  # &facet.limit=5
  # &facet.limit=5
  # &facet.offset=0
  # &facet.offset=0
  # &facet.offset=0
  # &facet.mincount=1
  # &facet.mincount=1
  # &facet.mincount=1
  # &facet=true
  # &forceElevation=false    does this mean it's not using elevation results?       :http://wiki.apache.org/solr/QueryElevationComponent
  # &enableElevation=true    false kills elevation (preset results in an xml config file)


  # <requestHandler name="ezpublish" class="solr.DisMaxRequestHandler">
  # −
  # <lst name="defaults">
  # <str name="echoParams">explicit</str>
  # <float name="tie">0.01</float>
  # <str name="qf">
  #         ezf_df_text
  #       </str>
  # <str name="pf">
  #         ezf_df_text
  #       </str>
  # <str name="bf">
  # 
  #       </str>
  # <str name="fl">
  #         meta_
  #       </str>
  # −
  # <!--
  #  mm explanation: for the values below:
  #              1, 2 keywords: at least one must match
  #              from 3-5 keywords, at least 2-4 must match
  #              from 6-7 keywords, at least 4-5 must match
  #              above 7 keywords, 60% of them must match
  # 
  # -->
  # <str name="mm">
  #         1<1 2<-1 5<-2 7<60%
  #       </str>
  # <int name="ps">100</int>
  # <str name="q.alt">*:*</str>
  # </lst>
  # −
  # <arr name="last-components">
  # <str>spellcheck</str>
  # <str>elevator</str>
  # </arr>
  # </requestHandler>



  # <requestHandler name="tki" class="solr.SearchHandler">
  # <!-- default values for query parameters -->
  # −
  # <lst name="defaults"> # provides default param values that will be used if the param does not have a value specified at request time. 
  # <str name="defType">dismax</str>
  # <float name="tie">0.01</float>
  # −
  # <str name="qf">
  # 
  #          title_t^10 keyword.text^7 description_t^5 location_t dc.format dc.right dc.subject topics.all.text contentprovider contentsource strand learningarea keylearningobjective educationalvalue host site institution_name_t url ezf_df_text
  # 
  # </str>
  # <str name="hl.fl">ezf_df_text</str>
  # </lst>
  # −
  # <lst name="appends"> # provides param values that will be used in addition to any values specified at request time (or as defaults. 
  # −
  # <str name="fq">
  # 
  #         meta_anon_access_b:true AND (url:[* TO *] AND url:http AND -url:cmis.cwa.co.nz AND -url:"http\://admin") AND -keyword:waec AND -keyword:moec AND englishstatus:live
  # 
  # </str>
  # −
  # <str name="bq">
  # 
  #         url:.nz^50 (dc.right:Ministry of Education, New Zealand)^100
  # 
  # </str>
  # </lst>
  # −
  # <arr name="last-components">
  # <str>spellcheck</str>
  # <str>elevator</str>
  # </arr>
  # </requestHandler>
  # −
  # <!--


  attr_accessor :base, :q, :qf, :fl

  BASE = 'http://search.tki.org.nz:8983/solr/select?'

  # Values set at initialize can always be overwritten
  # by seed.
  def initialize
    @q = nil
    @fl = '*,+score'
  end

  # A class the populated the request with a hash of values.
  # Unfinished.
  def seed(hash)
    hash.each do |k,v|
      #if k == :qf
      #  k = '@' + k.to_s
      #  self.instance_variable_set(k.to_sym, build_qf(v))
      #else

      k = '@' + k.to_s
      self.instance_variable_set(k.to_sym, v)
    end
    self
  end

  # Returns the full request. Called by the get_results method
  # in Query.
  def full
    request = String.new
    request << BASE
    request << 'q=' + @q
    request << '&qt=tki' #jesus what is this doing?
    request << '&fl=' + @fl
    # request << 'qf=' + @qf
    request
  end

end

