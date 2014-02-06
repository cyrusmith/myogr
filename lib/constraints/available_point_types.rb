module Constraints
  class AvailablePointTypes

    AVAILABLE_POINT_TYPES = [
        { request_name: :issue_point, class_name: 'Distribution::IssuePoint'},
        { request_name: :mobile_issue_point, class_name: 'Distribution::MobileIssuePoint'},
    ]

    def self.matches?(request)
      AVAILABLE_POINT_TYPES.map{|type| type[:request_name]}.include?(request[:point_type].to_sym)
    end
  end
end