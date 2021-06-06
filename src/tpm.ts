/*
 *  tpm - the package manager for Linux.
 *  Copyright (C) 2021 Sora Tonami
 *
 *  This file is part of tpm.
 *
 *  tpm is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  tpm is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with tpm.  If not, see <https://www.gnu.org/licenses/>.
 */

'use strict';

const Getopt: any = require('node-getopt');
const os: any = require('os');

const ENV_LANG: string = process.env.LANG !== undefined && process.env.LANG !== 'C' ? process.env.LANG : 'en_US';
const VERSION: string = process.env.npm_package_version || require('../package.json').version;

function main(): void {
    if(os.type().toString() === 'Windows') {
        console.error('Error: Windows is not supported');
        process.exit(2);
    }
    Msg.init(ENV_LANG.split('.')[0]);
    let commands: string[] = [
        `  find     ${Msg.getMessage('cmd_find')}`,
        `  help     ${Msg.getMessage('cmd_help')}`,
        `  install  ${Msg.getMessage('cmd_install')}`,
        `  sync     ${Msg.getMessage('cmd_sync')}`,
        `  upgrade  ${Msg.getMessage('cmd_upgrade')}`,
        `  version  ${Msg.getMessage('cmd_version')}`
    ];
    let getopt: any = Getopt.create([
        ['y', 'yes', Msg.getMessage('opt_yes')]
    ]).bindHelp().setHelp(Msg.getMessage('usage').replace(/\$\$COMMANDS\$\$/g, commands.join('\n'))).parseSystem();
    let opts: {[key: string]: boolean};
    for(const opt of getopt.options) {
        switch(opt) {
            case 'y':
                opts.y = true;
                break;
            default:
                console.error(Msg.getMessage('invalid_option'));
                process.exit(3);
        }
    }
    if(!getopt.argv) {
        console.error(Msg.getMessage('invalid_command'));
        process.exit(4);
    }
    switch(getopt.argv[0]) {
        case 'find':
            break;
        case 'help':
            getopt.showHelp();
            process.exit(0);
        case 'install':
            break;
        case 'sync':
            break;
        case 'upgrade':
            break;
        case 'version':
            break;
        default:
            console.error(Msg.getMessage('invalid_command'));
            process.exit(4);
    }
    process.exit(0);
}

main();
