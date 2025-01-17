#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

set -x
set -e

configurePrologs() {
    aws s3 cp --quiet "${post_install_base}/scripts/debug_prolog.sh" "${SLURM_ETC}/" --region "${cfn_region}" || exit 1
    aws s3 cp --quiet "${post_install_base}/scripts/debug_epilog.sh" "${SLURM_ETC}/" --region "${cfn_region}" || exit 1
    chmod +x "${SLURM_ETC}/debug_prolog.sh"
    chmod +x "${SLURM_ETC}/debug_epilog.sh"
    echo "TCPTimeout=10" >> "${SLURM_ETC}/slurm.conf"
    echo "EioTimeout=120" >> "${SLURM_ETC}/slurm.conf"
    #flatten the slurm tree
    echo "" >> "${SLURM_ETC}/slurm.conf"
    echo "#CUSTOM" >> "${SLURM_ETC}/slurm.conf"
    echo "TreeWidth=65533" >> "${SLURM_ETC}/slurm.conf"

}

restartSlurmDaemons() {
    systemctl restart slurmctld
}

# main
# ----------------------------------------------------------------------------
main() {
    echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] 07.configure.slurm.prologs.headnode.sh: START" >&2
    configurePrologs
    restartSlurmDaemons
    echo "[INFO][$(date '+%Y-%m-%d %H:%M:%S')] 07.configure.slurm.prologs.headnode.sh: STOP" >&2
}

main "$@"