#include <unistd.h>
#include <getopt.h>

#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>

#include <utility>

using std::make_pair;
using std::pair;

void printHelp()
{
    printf("Usage: %s 错误码[ 错误码 错误码...]\n",program_invocation_short_name);
    return ;
}

pair<int,bool> str2errcode(const char *str)
{
    char *bad_ptr = nullptr;
    int result = strtol(str,&bad_ptr,0);
    if (bad_ptr != str + strlen(str))
        return make_pair(0,false);
    return make_pair(result,true);
}

int
main(int argc,char **argv)
{
    bool showHelpDoc = false;
    struct option options[] {
        {"help",no_argument,nullptr,'h'},
        {nullptr,0,nullptr,0}
    };
    optind = 0;
    opterr = 0;
    int getopt_ret;
    while ((getopt_ret = getopt_long(argc,argv,"h",options,nullptr)) != -1) {
        switch (getopt_ret) {
        case 'h':
            showHelpDoc = true;
            break;
        default:
            break;
        }
    }
    if (argc < 2 || showHelpDoc) {
        printHelp();
        return 1;
    }

    int errcodenum = argc - optind;
    if (errcodenum == 1) {
        auto result = str2errcode(argv[optind]);
        if (result.second == false) {
            printf("%s 不是合法的错误码!\n",argv[optind]);
            return 1;
        } else {
            puts(strerror(result.first));
        }
    } else {
        for (int i = optind; i < argc; ++i) {
            printf("%s: ",argv[i]);
            auto result = str2errcode(argv[i]);
            if (result.second == false)
                printf("不是合法的错误码!");
            else
                printf("%s",strerror(result.first));
            putchar('\n');
        }
    }
    return 0;
}


