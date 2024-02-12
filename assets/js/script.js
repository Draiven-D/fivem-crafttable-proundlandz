var progress = false;

$(function() {
    var actionContainer = $("#actionmenu");
    var item
    window.addEventListener('message', function(event) {
        item = event.data
        if (item.loaditem) {
            $('.list-grid').html("")
            $('#catagory-list').html("")
            $('.require_list').html("")
            $('.refine_box').html("")
            $('#title-item').html("")
            $('#btn-craft').attr('data-item', "")
            $('#btn-craft').attr('data-catagory', "")
            $('#btn-craft').attr('data-plus', '0')
            // $('#head-id').html("ID : "+item.pid)
            $(item.catagory).each(function(index, values) {
                var catagory_id = index
                var catagory_name = this["NAME"]
                var catagory_item_list = this["ITEM_LIST"]
                var active_class = ""
                if (index === 0)
                    active_class = "active"

                $('#catagory-list').append('<button data-catagory-id="' + catagory_id + '" data-catagory="' + catagory_name + '" class="btn btn-secondary w-100 btn-catagory btn-raised ' + active_class + '" type="button">' + catagory_name + '</button>')
                
                if (index === 0) {
                    $(catagory_item_list).each(function() {

                        var item_name = this['item_name']
                        var item_index = this['item_index']

                        if (item_name.search('WEAPON_') == 0) {
							var item_label = item.wpdata[item_name].label
						} else if (item_name.search('GADGET_') == 0)  {
							var item_label = item_name.replace('GADGET_', '')
						} else {
							var item_label = item.itemdata[item_name].label
						}
                        $('.list-grid').append('<div class="slot"><div class="btn-item-require" data-item-id="' + item_index + '" data-catagory-id="' + catagory_id + '" data-catagory="' + catagory_name + '"><img src="nui://esx_inventoryhud/html/img/items/' + item_name + '.png" class="card-img w-100 d-block"><p class="text-white text-center" >' + item_label + '</p></div> </div>')
                    })
                }
            })
        }
        if (item.showmenu) {
            actionContainer.fadeIn();
            $(".progress-container").fadeOut();
            $(".main").removeClass('opClass');
        }
        if (item.hidemenu) {
            $(".main").removeClass('opClass');
            $(".progress-container").fadeOut();
            actionContainer.fadeOut();
            progress = false;
        }
    });

    $(document).on('click', '.btn-item-require', function(e) {
        // console.log('ttt')
        var get_catagory_id = Number(this.getAttribute('data-catagory-id'))
        var get_catagory_name = this.getAttribute('data-catagory')
        var get_item_index = this.getAttribute('data-item-id')
        $('.require_list').html("")
        $('.refine_box').html("")
        $('#btn-craft').attr('data-item', get_item_index)
        $('#btn-craft').attr('data-catagory', get_catagory_name)
        $('#btn-craft').attr('data-plus', '0')
        $('.btn-item-require').each(function(e) {
            $(this).removeClass('active')
        })
        $(this).addClass('active')
        $(item.catagory[get_catagory_id]['ITEM_LIST']).each(function(index, values) {
            var item_index = this['item_index']
            var item_name = this['item_name']
            var item_require = this['item_require']
            var require_equipment = this['equipment']
            var fail_item = this['fail_item']
            var fail_chance = this['fail_chance']
            var cost = this['cost']
            var cost_type = this['cost_type']
            var max_amount = this['max_amount']
            var min_amount = this['min_amount']
            var blessed = this['blessed']
            var protection = this['protection']
            $('#cracft-amount').attr('max', Number(max_amount))
            $('#cracft-amount').attr('min', Number(min_amount))
            if (item_index === get_item_index) {
                if (item_name.search('WEAPON_') == 0) {
                    var item_label = item.wpdata[item_name].label
                } else if (item_name.search('GADGET_') == 0)  {
                    var item_label = item_name.replace('GADGET_', '')
                } else {
                    if (this['additem']) {
                        var item_label = item.itemdata[item_name].label + ' x ' + this['additem']
                    } else {
                        var item_label = item.itemdata[item_name].label
                    }
                }
                $('#title-item').html('&nbsp;' + item_label.toUpperCase() + '')
                // $('#btn-craft').attr('data-arry', JSON)
                var rate = Number(100.0 - fail_chance);
                $(".require_list").append('<h5 class="mt-1 mb-2">โอกาสสำเร็จ :&nbsp;<span style="color: rgb(255, 0, 102);">' + rate.toFixed(1) + '</span><span id="plus"></span> %</h5>')
                $(".require_list").append('<h5 class="mb-2">• ส่วนประกอบที่ต้องใช้</h5>')
                var require, x;
                require = item_require;
                for (x in require) {
                    if (x.search('WEAPON_') == 0) {
                        var x_item_label = item.wpdata[x].label
                    } else if (x.search('GADGET_') == 0)  {
                        var x_item_label = x.replace('GADGET_', '')
                    } else {
                        var x_item_label = item.itemdata[x].label
                    }
                    $(".require_list").append('<div><img src="nui://esx_inventoryhud/html/img/items/' + x + '.png" width="15%" alt=""><span>' + x_item_label + ' :&nbsp;' + require[x] + '</span> </div>')
                }
                if (cost_type === 'black_money') {
                    $(".require_list").append('<div><img src="nui://esx_inventoryhud/html/img/items/black_money.png" width="15%" alt=""> <span>เงินผิดกฏหมาย :&nbsp;$' + Number(cost) + '</span> </div>')
                } else {
                    $(".require_list").append('<div><img src="nui://esx_inventoryhud/html/img/items/cash.png" width="15%" alt=""> <span>เงินสด :&nbsp;$' + Number(cost) + '</span> </div>')
                }
                if (JSON.stringify(require_equipment).length > 2) {
                    $(".require_list").append('<h5 class="mt-1 mb-2">• อุปกรณ์ที่จำเป็น</h5>')
                    var equipment, e;
                    equipment = require_equipment;
                    for (e in equipment) {
                        if (e.search('WEAPON_') == 0) {
                            var e_item_label = item.wpdata[e].label
                        } else if (e.search('GADGET_') == 0)  {
                            var item_label = e.replace('GADGET_', '')
                        } else {
                            var e_item_label = item.itemdata[e].label
                        }
                        $(".require_list").append('<div><img src="nui://esx_inventoryhud/html/img/items/' + e + '.png" width="15%" alt=""><span>' + e_item_label + '</span> </div>')
                    }
                }
                if (JSON.stringify(fail_item).length > 2) {
                    $(".require_list").append('<h5 class="mt-1 mb-2">• เมื่อล้มเหลวที่จะได้รับ</h5>')
                    var fail, f;
                    fail = fail_item;
                    for (f in fail_item) {
                        if (f.search('WEAPON_') == 0) {
                            var f_item_label = item.wpdata[f].label
                        } else if (f.search('GADGET_') == 0)  {
                            var f_item_label = f.replace('GADGET_', '')
                        } else {
                            var f_item_label = item.itemdata[f].label
                        }
                        $(".require_list").append('<div><img src="nui://esx_inventoryhud/html/img/items/' + f + '.png" width="15%" alt=""><span>' + f_item_label + ' :&nbsp;' + fail[f] + '</span> </div>')
                    }
                }
                if (blessed) {
                    var item_blessed = this['item_blessed']
                    if (item_blessed  != "") {
                        $('#btn-craft').attr('data-plus', '1')
                        var blessed_rate = this['blessed_rate']
                        $(".refine_box").append('<div id="blessed_box"><input type="checkbox" name="blessed" id="blessed" data="' + blessed_rate + '" onclick="blessed()"><label for="blessed"><span>' + item.itemdata[item_blessed].label + '</span><img src="nui://esx_inventoryhud/html/img/items/' + item_blessed + '.png" /></label></div>')
                    }
                }
                if (protection) {
                    $(".require_list").append('<h6 class="mt-1 mb-2" style="color: red;">** เมื่อล้มเหลวมีโอกาส 20% ที่อาวุธจะลดขั้น</h6>')
                    var item_protec = this['item_protec']
                    if (item_protec  != "") {
                        $('#btn-craft').attr('data-plus', '2')
                        $(".refine_box").append('<div id="antidown_box"><input type="checkbox" name="antidown" id="antidown"><label for="antidown"><span>' + item.itemdata[item_protec].label + '</span><img src="nui://esx_inventoryhud/html/img/items/' + item_protec + '.png" /></label></div>')
                    }
                }
                return false
            }
        })
    })
    $(document).on('click', '.btn-catagory', function(e) {
        $('.btn-catagory').each(function() {
            $(this).removeClass('active')
        })
        $(this).addClass('active')
        $('.list-grid').html("")
        $('.require_list').html("")
        $('.refine_box').html("")
        $('#title-item').html("")
        var get_catagory_id = Number(this.getAttribute('data-catagory-id'))
        $(item.catagory).each(function(index, values) {
            var catagory_id = index
            var catagory_name = this["NAME"]
            var catagory_item_list = this["ITEM_LIST"]
            var active_class = ""
            if (index === 0)
                active_class = "active"
            if (index === get_catagory_id) {
                $(catagory_item_list).each(function() {
                    var item_name = this['item_name']
                    var item_index = this['item_index']
                    if (item_name.search('WEAPON_') == 0) {
                        var item_label = item.wpdata[item_name].label
                    } else if (item_name.search('GADGET_') == 0)  {
                        var item_label = item_name.replace('GADGET_', '')
                    } else {
                        var item_label = item.itemdata[item_name].label
                    }
                    $('.list-grid').append('<div class="slot"><div class="btn-item-require" data-item-id="' + item_index + '" data-catagory-id="' + catagory_id + '" data-catagory="' + catagory_name + '"><img src="nui://esx_inventoryhud/html/img/items/' + item_name + '.png" class="card-img w-100 d-block"><p class="text-white text-center" >' + item_label + '</p></div> </div>')
                })
            }
        })
    })

    document.onkeyup = function(data) {
        if (data.which == 27) {
            if (actionContainer.is(":visible")) {
                if (!progress) {
                    sendData("exit", data)
                }
            }
        }
    };
});

function sendData(name, data) {
    $.post("http://crafting/" + name, JSON.stringify(data), function(datab) {
        if (datab != "ok") {
            //console.log(datab);
        }
    });
}

function blessed() {
    var checkBox = document.getElementById("blessed");
    if (checkBox.checked == true) {
        $("#plus").append(' + ' + checkBox.getAttribute("data") + ' ')
    } else {
        $("#plus").html("")
    }
}

function craft(eliment) {
    if (!progress) {
        const data_item = eliment.getAttribute('data-item')
        const amount = parseInt($('#cracft-amount').val())
        const catagory = eliment.getAttribute('data-catagory')
        const upgrade = eliment.getAttribute('data-plus')
        var blessed = false;
        var protection = false;
        if (upgrade > 0) {
            blessed = (document.getElementById("blessed").checked == true) ? true : false;
            if (upgrade > 1) {
                protection = (document.getElementById("antidown").checked == true) ? true : false;
            }
        }
        // const data_arry = eliment.getAttribute('data-arry')
        if (data_item != "") {
            data = {
                'item_index': data_item,
                'item_amount': amount,
                'catagory': catagory,
                'blessed': blessed,
                'protection': protection,
                // 'data': data_arry,
            }
            
            if (Number.isInteger(data.item_amount) && data.item_amount > 0 ) {
                progress = true;
                $(".main").addClass('opClass');
                $(".progress-container").fadeIn('fast', function() {
                    $("#progress-bar").stop().css({"width": 0}).animate({
                        width: '100%'
                    }, {
                        duration: parseInt(6000),
                        complete: function() {
                            $(".progress-container").fadeOut('fast', function() {
                                $("#progress-bar").css("width", 0);
                                $(".main").removeClass('opClass');
                                if (progress) {
                                    progress = false;
                                    sendData("ButtonClick", data)
                                }
                            })
                        }
                    });
                });
            }
        }
    }
}