
# Various constants - each should be a Request object ready for placement in a Query.
BASELINE = Request.new.seed({
})

TKI_HANDLER = Request.new.seed({
  :qt => 'tki',
  :dismax => true,
  :bq => '-url:/Media/',
})

TKI_NEWER_APROX = Request.new.seed({
  :dismax => true,
  :qf => 'title_t^10+keyword.text^7+description_t^5+location_t+dc.format+dc.right+dc.subject+topics.all.text+contentprovider+contentsource+strand+learningarea+keylearningobjective+educationalvalue+host+site+institution_name_t+url+ezf_df_text',
  :fq => 'meta_anon_access_b:true AND (url:[* TO *] AND url:http AND -url:cmis.cwa.co.nz AND -url:"http\://admin") AND -keyword:waec AND -keyword:moec AND englishstatus:live',
  :bq => 'url:.nz^50 (dc.right:Ministry of Education, New Zealand)^100 -url:/Users/ -url:/Media/',
})

TKI_DEFAULT = Request.new.seed({
  :dismax => true,
  :qf => 'title_t^10+keyword.text^7+description_t^5+location_t+dc.format+dc.right+dc.subject+topics.all.text+contentprovider+contentsource+strand+learningarea+keylearningobjective+educationalvalue+host+site+institution_name_t+url+ezf_df_text',
  :fq => 'meta_anon_access_b:true AND (url:[* TO *] AND url:http AND -url:cmis.cwa.co.nz AND -url:"http\://admin") AND -keyword:waec AND -keyword:moec AND englishstatus:live',
  :bq => 'url:.nz^50 (dc.right:Ministry of Education, New Zealand)^100',
})

TKI_BETTER = Request.new.seed({
  :dismax => true,
  :qf => 'title_t^10+keyword.text^7+description_t^5+location_t+dc.format+dc.right+dc.subject+topics.all.text+contentprovider+contentsource+strand+learningarea+keylearningobjective+educationalvalue+host+site+institution_name_t+url+ezf_df_text',
  :fq => 'meta_anon_access_b:true AND (url:[* TO *] AND url:http AND -url:cmis.cwa.co.nz AND -url:"http\://admin") AND -keyword:waec AND -keyword:moec AND englishstatus:live',
  :bq => 'url:.nz^30 (dc.right:Ministry of Education, New Zealand)^50 -url:/Media/',
	:qs => '3',
	:mm => '-1',
  :pf => 'title_t^30+ezf_df_text^30+description_t^20',
  :ps => '1',
})

TKI_FORK = Request.new.seed({
  :dismax => true,
  :qf => 'title_t^10+keyword.text^7+description_t^5+location_t+dc.format+dc.right+dc.subject+topics.all.text+contentprovider+contentsource+strand+learningarea+keylearningobjective+educationalvalue+host+site+institution_name_t+url+ezf_df_text',
  :fq => 'meta_anon_access_b:true AND (url:[* TO *] AND url:http AND -url:cmis.cwa.co.nz AND -url:"http\://admin") AND -keyword:waec AND -keyword:moec AND englishstatus:live',
  :bq => 'url:.nz^50 (dc.right:Ministry of Education, New Zealand)^100',
	:qs => '3',
	:mm => '-3',
  :pf => 'title_t^50+ezf_df_text^50+description_t^30',
  :ps => '3',
})

SCRATCH = Request.new.seed({
  :dismax => true,
  :qf => 'title_t^30+keyword.text^7+description_t^5+location_t+dc.format+dc.right+dc.subject+topics.all.text+contentprovider+contentsource+strand+learningarea+keylearningobjective+educationalvalue+host+site+institution_name_t+url+ezf_df_text',
  :fq => 'meta_anon_access_b:true AND (url:[* TO *] AND url:http AND -url:cmis.cwa.co.nz AND -url:"http\://admin") AND -keyword:waec AND -keyword:moec AND englishstatus:live',
  :bq => '-url:/Media/Images/ AND -url:ezportal-staging',
  :pf => 'title_t^300+ezf_df_text^100+description_t^60',
  :ps => '0',
})

FILTER = Request.new.seed({
  :dismax => true,
  :qf => 'title_t^30+keyword.text^7+description_t^5+location_t+dc.format+dc.right+dc.subject+topics.all.text+contentprovider+contentsource+strand+learningarea+keylearningobjective+educationalvalue+host+site+institution_name_t+url+ezf_df_text',
  :fq => 'learningarea:learning+languages AND userlevel:Secondary',
  :bq => '-url:/Media/Images/ AND -url:ezportal-staging',
  :pf => 'title_t^300+ezf_df_text^100+description_t^60',
  :ps => '0',
})



# 3.1 create sloppy phrase queries with the pf (phrase fields) and ps (phrase slop) parameters in solr
#    or phrase queries, spannear queries in lucene.
# 3.2 PhraseQuery is impartial to term order when enough slop is specified. Interestingly, you can easily extend QueryParser to use a SpanNearQuery with SpanTermQuery clauses instead, and force phrase queries to only match fields with the terms in the same order as specified.
#    Given enough slop, PhraseQuery will match terms out of order in the original text. There is no way to force a PhraseQuery to match in order (except with slop of 0 or 1). However, SpanNearQuery does allow in-order matching.
# 4. The general strategy is to index the content twice, using different fields with different fieldTypes (and different analyzers   associated with those fieldTypes). One analyzer will contain a lowercase filter for case-insensitive matches, and one will preserve case for exact-case matches.
#  Use copyField commands in the schema to index a single input field multiple times. Once the content is indexed into multiple fields that are analyzed differently, query across both fields.
#

