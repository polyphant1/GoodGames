module ApplicationHelper
    def flash_class(type)
        case type
            when "alert"
                "alert-danger"
            when "notice"
                "alert-info"
            when "error"
                "alert-danger"
            else
                ""
        end
    end
end
