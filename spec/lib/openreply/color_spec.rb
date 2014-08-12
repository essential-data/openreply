require 'rails_helper'

describe Openreply::Color do

  describe "::color" do
    context "color <0;2)" do
      it "returns pink" do
        expect(Openreply::Color.color(0)).to eq "pink"
        expect(Openreply::Color.color(1)).to eq "pink"
        expect(Openreply::Color.color(2)).not_to eq "pink"
      end
    end

    context "color <2;4)" do
      it "returns yellow" do
        expect(Openreply::Color.color(2)).to eq "yellow"
        expect(Openreply::Color.color(3)).to eq "yellow"
        expect(Openreply::Color.color(4)).not_to eq "yellow"
      end
    end

    context "color <4;5>" do
      it "returns green" do
        expect(Openreply::Color.color(4)).to eq "green"
        expect(Openreply::Color.color(5)).to eq "green"
        expect(Openreply::Color.color(6)).not_to eq "green"
      end
    end

    context "color (5;..)" do
      it "returns gray" do
        expect(Openreply::Color.color(6)).to eq "gray"
        expect(Openreply::Color.color(-1)).to eq "gray"
        expect(Openreply::Color.color(5)).not_to eq "gray"
      end
    end

    context "color is not numeric" do
      it "return gray" do
        expect(Openreply::Color.color("color")).to eq "gray"
      end
    end
  end

  describe "::color_change" do
    context "color :unknown" do
      it "returns gray" do
        expect(Openreply::Color.color_change(:unknown)).to eq "gray"
      end
    end

    context "color > 1" do
      it "returns green" do
        expect(Openreply::Color.color_change(10)).to eq "green"
      end
    end

    context "color < 1" do
      it "returns green" do
        expect(Openreply::Color.color_change(-10)).to eq "pink"
      end
    end

    context "color == 0" do
      it "returns green" do
        expect(Openreply::Color.color_change(0)).to eq "yellow"
      end
    end
  end
end