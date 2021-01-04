CALL_ASSETS="${RECON_BASH_BASEPATH}/call_assetfinder.sh"
CALL_AMASS="${RECON_BASH_BASEPATH}/call_amass.sh"
CALL_SUBFINDER="${RECON_BASH_BASEPATH}/call_subfinder.sh"
CALL_SUBLIST3R="${RECON_BASH_BASEPATH}/call_sublist3r.sh"
CALL_MASSDNS="${RECON_BASH_BASEPATH}/call_massdns.sh"
CALL_HTTPROBE="${RECON_BASH_BASEPATH}/call_httprobe.sh"
CALL_MEG="${RECON_BASH_BASEPATH}/call_meg.sh"

CALL_FINDJS="${RECON_BASH_BASEPATH}/call_findjs.sh"
CALL_CREATE_WORDLIST_FROM_JS="${RECON_BASH_BASEPATH}/call_create_wordlist_from_js.sh"
CALL_EXTRACT_URLS="${RECON_BASH_BASEPATH}/call_extract_urls.sh"
CALL_GET_CONTENT_FOR_EXTRACTED_URLS="${RECON_BASH_BASEPATH}/call_get_content_for_extracted_urls.sh"
CALL_DIRSEARCH="${RECON_BASH_BASEPATH}/call_dirsearch.sh"
CALL_DECODE_BASE64_STRINGS="${RECON_BASH_BASEPATH}/call_decode_base64_strings.sh"

CALL_MASSCAN="${RECON_BASH_BASEPATH}/call_masscan.sh"


program_name=$1

if ([ -z "$program_name" ]); then
	echo "Searching for all targets"

	"$CALL_ASSETS"
	"$CALL_AMASS"
	"$CALL_SUBFINDER"
	"$CALL_SUBLIST3R"

	find $TARGETS_PATH/*/domains_final -size  0 -print0 |xargs -0 rm --

	"$CALL_MASSDNS"
	"$CALL_HTTPROBE"
	"$CALL_MEG"

	"$CALL_FINDJS"
	"$CALL_CREATE_WORDLIST_FROM_JS"
	"$CALL_EXTRACT_URLS"
	# "$CALL_GET_CONTENT_FOR_EXTRACTED_URLS"
	"$CALL_DIRSEARCH"
	"$CALL_DECODE_BASE64_STRINGS"

	"$CALL_MASSCAN"
	"$CALL_HTTPROBE"

else
	echo "Searching for $program_name only"
	"$CALL_ASSETS" $program_name
	"$CALL_AMASS" $program_name
	"$CALL_SUBFINDER" $program_name
	"$CALL_SUBLIST3R" $program_name

	find $TARGETS_PATH/*/domains_final -size  0 -print0 |xargs -0 rm --

	"$CALL_MASSDNS" $program_name
	"$CALL_HTTPROBE" $program_name
	"$CALL_MEG" $program_name

	"$CALL_FINDJS" $program_name
	"$CALL_CREATE_WORDLIST_FROM_JS" $program_name
	"$CALL_EXTRACT_URLS" $program_name
	# "$CALL_GET_CONTENT_FOR_EXTRACTED_URLS"
	"$CALL_DIRSEARCH" $program_name
	"$CALL_DECODE_BASE64_STRINGS" $program_name

	"$CALL_MASSCAN" $program_name
	"$CALL_HTTPROBE" $program_name
	
fi
