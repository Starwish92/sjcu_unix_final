#!/usr/bin/bash

#유닉스 및 리눅스 시스템 기말과제
#소프트웨어 공학과 20931566 박영진

repeat=1
question1="1.콜라:850원, 2.사이다:800원, 3.환타:750원, 4.생수:500원"
question2="금액을 입력하세요 : "
question3="메뉴를 선택하세요 : "

bank_1000=5
bank_500=10
bank_100=10
bank_50=10
bank_10=30

ch_1000=0
ch_500=0
ch_100=0
ch_50=0
ch_10=0

mac_money_total=0
change=0
money=0
product_price=0

function mac_money_sum()
{
    para_1000=$1
    para_500=$2
    para_100=$3
    para_50=$4
    para_10=$5

    let mac_money_total=1000*para_1000+500*${para_500}+100*${para_100}+50*${para_50}+10*${para_10}
}

function check_num_to_product()
{
    case $1 in
        1) product_price=850;;
        2) product_price=800;;
        3) product_price=750;;
        4) product_price=500;;
        *) product_price=0;;
    esac
}

function calculate_change()
{
    local ret_str=""

    let change=money-product_price
    if (( $2 > $3 )); then
        echo "지불하신 금액이 부족합니다."
    elif (( $1 < $3 - $4 )); then
        echo "최대 거스름돈을 초과합니다."
    else
        echo "잔돈 : ${change}"
        let ch_1000=change/1000
        if (( ch_1000 >= 5 )); then
            ch_1000=5
            let change-=5000
        else
            let change-=1000*${ch_1000}
        fi
        #let change=change%1000
        let ch_500=change/500
        if (( ch_500 >= 10 )); then
            ch_500=10
            let change-=5000
        else
            let change-=500*${ch_500}
        fi
        #let change=change%500
        let ch_100=change/100
        if (( ch_100 >= 10 )); then
            ch_100=10
            let change-=1000
        else
            let change-=100*${ch_100}
        fi
        #let change=change%100
        let ch_50=change/50
        if (( ch_50 >= 10 )); then
            ch_50=10
            let change-=500
        else
            let change-=50*${ch_50}
        fi
        #let change=change%50
        let ch_10=change/10
        if (( ch_1000 > bank_1000 || ch_500 > bank_500 || ch_100 > bank_100 || ch_50 > bank_50 || ch_10 > bank_10 )); then
            echo "거스름돈 수량을 초과합니다."
        else
            let bank_1000-=ch_1000
            let bank_500-=ch_500
            let bank_100-=ch_100
            let bank_50-=ch_50
            let bank_10-=ch_10
            if (( ch_1000 > 0 )); then
                ret_str+="천원:${ch_1000}개 "
            fi
            if (( ch_500 > 0 )); then
                ret_str+="오백원:${ch_500}개 "
            fi
            if (( ch_100 > 0 )); then
                ret_str+="백원:${ch_100}개 "
            fi
            if (( ch_50 > 0 )); then
                ret_str+="오십원:${ch_50}개 "
            fi
            if (( ch_10 > 0 )); then
                ret_str+="십원:${ch_10}개 "
            fi
            trimmed_string="${ret_str%"${ret_str##*[![:space:]]}"}"
            echo "${trimmed_string//" "/,}"
            # printf "${ret_str}\n"
        fi
    fi
}

while [ ${repeat} -le 10 ];
do
    echo $question1
    printf "%s" $question2
    read money_input
    money="${money_input%원}"
    if (( money > 12650 )); then
        echo "최대 거스를 수 있는 11800을 초과합니다."
        continue
    fi
    printf "%s" $question3
    read menu_num
    check_num_to_product ${menu_num}

    mac_money_sum bank_1000 bank_500 bank_100 bank_50 bank_10

    calculate_change ${mac_money_total} ${product_price} ${money} ${product_price}

    repeat=$(( ${repeat}+1 ))
done
