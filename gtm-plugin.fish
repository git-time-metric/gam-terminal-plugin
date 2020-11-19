#!/usr/bin/env fish

set -x GTM_STATUS ""
set -x GTM_NEXT_UPDATE 0
set -x GTM_LAST_DIR {$PWD}

function gtm_record_terminal --on-event fish_prompt
	set epoch (date +%s)
	if test $GTM_LAST_DIR != {$PWD} -o $epoch -ge $GTM_NEXT_UPDATE
		set -x GTM_NEXT_UPDATE (math $epoch + 30)
		set -x GTM_LAST_DIR {$PWD}
		if set -q GTM_STATUS_ONLY
			set -x GTM_STATUS (gtm status -total-only)
		else
			set -x GTM_STATUS (gtm record -terminal -status)
		end
		if test $status -ne 0
			echo "Error running 'gtm record -terminal -status', you may need to install gtm or upgrade to the latest"
			echo "See http://www.github.com/git-time-metric/gtm for how to install"
		end
	end
end
