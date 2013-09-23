# encoding: utf-8
class AuthorizedController < ApplicationController
  load_and_authorize_resource
end