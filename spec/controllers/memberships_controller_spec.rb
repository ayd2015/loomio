require 'spec_helper'

describe MembershipsController do
  context 'signed in user' do
    before :each do
      @user = User.make!
      sign_in @user
    end

    it "requests membership to a group" do
      @group = Group.make!
      # note trying to sneek member level access.. should be ignored
      post :create, :membership => {:group_id => @group.id, :access_level => 'member'}
      response.should be_redirect
      assigns(:membership).user.should == @user
      assigns(:membership).group.should == @group
      assigns(:membership).access_level.should == 'request'
    end

    context 'a group member' do
      before :each do
        @group = Group.make!
        @group.add_member!(@user)
      end

      it "authorizes a membership request for another user" do
        @new_user = User.make!
        @group.add_request!(@new_user)
        @membership = @group.membership_requests.first
        post :update, :id => @membership.id, :membership => {:access_level => 'member'}
        flash.notice.should =~ /success/
        response.should redirect_to(@group)
        assigns(:membership).access_level.should == 'member'
        assigns(:membership).id.should == @membership.id
      end
    end

    context 'a non group member' do
      before :each do
        @group = Group.make!
      end

      it "authorizes a membership request for another user" do
        @new_user = User.make!
        @group.add_request!(@new_user)
        @membership = @group.membership_requests.first
        post :update, :id => @membership.id, :membership => {:access_level => 'member'}
        flash.error.should =~ /fail/
        response.should redirect_to(@group)
        assigns(:membership).access_level.should == 'request'
        assigns(:membership).id.should == @membership.id
      end
    end
  end
end
