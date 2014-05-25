# -*- coding: utf-8 -*-

Plugin.create :tab_icon_size do
  i_tabs = []

  UserConfig[:tab_icon_size] ||= 24

  # replace tab_update_icon()
  Plugin[:gtk].instance_eval {
    alias :tab_update_icon_org :tab_update_icon

    def tab_update_icon(i_tab)
      ret = tab_update_icon_org(i_tab)

      tab = widgetof(i_tab)

      if tab
        tab.remove(tab.child) if tab.child
        if i_tab.icon.is_a?(String)
          tab.add(::Gtk::WebIcon.new(i_tab.icon, UserConfig[:tab_icon_size], UserConfig[:tab_icon_size]).show)
        else
          tab.add(::Gtk::Label.new(i_tab.name).show) end end
      ret
    end
  }

  on_boot do
    UserConfig.connect(:tab_icon_size) { |key, val, before, id|
      i_tabs.each { |i_tab|
        icon = i_tab.icon
        i_tab.set_icon nil
        i_tab.set_icon icon
      }
    }
  end

  settings "タブのアイコンサイズ" do
      adjustment("アイコンサイズ", :tab_icon_size, 1, 100)
  end

  on_tab_created do |i_tab|
    i_tabs << i_tab
    i_tab.set_icon i_tab.icon
  end
end
