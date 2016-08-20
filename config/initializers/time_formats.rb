# Date and Time formats
{
  simple: '%B %d, %Y',
  default: '%b %e, %Y',
  receipt: '%Y-%m-%d'
}.each do |k, v|
  Date::DATE_FORMATS[k] = v
  Time::DATE_FORMATS[k] = v
end
