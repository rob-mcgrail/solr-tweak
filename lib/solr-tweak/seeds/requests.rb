
# Various constants - each should be a Request object ready for placement in a Query.



BASELINE = Request.new.seed({
  :x => 'thing',
})

#<requestHandler name="tki" class="solr.SearchHandler">
#	<!-- default values for query parameters -->
#	<lst name="defaults">
#		<str name="defType">dismax</str>
#		<float name="tie">0.01</float>
#
#		<str name="qf">title_t^10 keyword.text^7 description_t^5 location_t dc.format dc.right dc.subject topics.all.text contentprovider contentsource strand learningarea keylearningobjective educationalvalue host site institution_name_t url ezf_df_text</str>
#<str name="hl.fl">ezf_df_text</str>

#	</lst>
#
#	<lst name="appends">
#
#		<str name="fq">meta_anon_access_b:true AND (url:[* TO *] AND url:http AND -url:cmis.cwa.co.nz AND -url:"http\://admin") AND -keyword:waec AND -keyword:moec AND englishstatus:live</str>
#		<str name="bq">url:.nz^50 (dc.right:Ministry of Education, New Zealand)^100</str>
#
#	</lst>

#	<arr name="last-components">
#		<str>spellcheck</str>
#		<str>elevator</str>
#	</arr>
#</requestHandler>


TKI_HANDLER = Request.new.seed({
  :qt => 'tki',
})

TKI_DEFAULT = Request.new.seed({
  :dismax => true,
  :qf => 'title_t^10+keyword.text^7+description_t^5+location_t+dc.format+dc.right+dc.subject+topics.all.text+contentprovider+contentsource+strand+learningarea+keylearningobjective+educationalvalue+host+site+institution_name_t+url+ezf_df_text',
  :fq => 'meta_anon_access_b:true AND (url:[* TO *] AND url:http AND -url:cmis.cwa.co.nz AND -url:"http\://admin") AND -keyword:waec AND -keyword:moec AND englishstatus:live',
  :bq => 'url:.nz^50 (dc.right:Ministry of Education, New Zealand)^100',
})

SCRATCH = Request.new.seed({
  :dismax => true,
  :qf => 'title_t^10+keyword.text^7+description_t^5+location_t+dc.format+dc.right+dc.subject+topics.all.text+contentprovider+contentsource+strand+learningarea+keylearningobjective+educationalvalue+host+site+institution_name_t+url+ezf_df_text',
  :fq => 'meta_anon_access_b:true AND (url:[* TO *] AND url:http AND -url:cmis.cwa.co.nz AND -url:"http\://admin") AND -keyword:waec AND -keyword:moec AND englishstatus:live',
  :bq => 'url:.nz^50 (dc.right:Ministry of Education, New Zealand)^100',
})





