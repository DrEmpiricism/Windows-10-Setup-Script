﻿Add-Type -AssemblyName "PresentationCore", "PresentationFramework", "WindowsBase"

#region Script Variables
$ToggleButtons = New-Object System.Collections.ArrayList($null)
#endregion

[xml]$xamlMarkup = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"                        
        x:Name="Window"
        Title="Windows 10 Setup Script" MinHeight="800" MinWidth="750" Height="800" Width="750" FontFamily="Sergio UI"
        FontSize="16" TextOptions.TextFormattingMode="Display" WindowStartupLocation="CenterScreen" 
        SnapsToDevicePixels="True" WindowStyle="None" ResizeMode="CanResizeWithGrip" AllowsTransparency="True" 
        ShowInTaskbar="True" Background="#FAFAFA"
        Foreground="{DynamicResource {x:Static SystemColors.WindowTextBrushKey}}">

    <Window.Resources>

        <!--#region Brushes -->

        <SolidColorBrush x:Key="RadioButton.Static.Background" Color="#FFFFFFFF"/>
        <SolidColorBrush x:Key="RadioButton.Static.Border" Color="#FF333333"/>
        <SolidColorBrush x:Key="RadioButton.Static.Glyph" Color="#FF333333"/>

        <SolidColorBrush x:Key="RadioButton.MouseOver.Background" Color="#FFFFFFFF"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.Border" Color="#FF000000"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.Glyph" Color="#FF000000"/>

        <SolidColorBrush x:Key="RadioButton.MouseOver.On.Background" Color="#FF4C91C8"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.On.Border" Color="#FF4C91C8"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.On.Glyph" Color="#FFFFFFFF"/>

        <SolidColorBrush x:Key="RadioButton.Disabled.Background" Color="#FFFFFFFF"/>
        <SolidColorBrush x:Key="RadioButton.Disabled.Border" Color="#FF999999"/>
        <SolidColorBrush x:Key="RadioButton.Disabled.Glyph" Color="#FF999999"/>

        <SolidColorBrush x:Key="RadioButton.Disabled.On.Background" Color="#FFCCCCCC"/>
        <SolidColorBrush x:Key="RadioButton.Disabled.On.Border" Color="#FFCCCCCC"/>
        <SolidColorBrush x:Key="RadioButton.Disabled.On.Glyph" Color="#FFA3A3A3"/>

        <SolidColorBrush x:Key="RadioButton.Pressed.Background" Color="#FF999999"/>
        <SolidColorBrush x:Key="RadioButton.Pressed.Border" Color="#FF999999"/>
        <SolidColorBrush x:Key="RadioButton.Pressed.Glyph" Color="#FFFFFFFF"/>

        <SolidColorBrush x:Key="RadioButton.Checked.Background" Color="#FF0063B1"/>
        <SolidColorBrush x:Key="RadioButton.Checked.Border" Color="#FF0063B1"/>
        <SolidColorBrush x:Key="RadioButton.Checked.Glyph" Color="#FFFFFFFF"/>

        <!--#endregion-->

        <Style x:Key="ToggleSwitchLeftStyle" TargetType="{x:Type ToggleButton}">
            <Setter Property="Background" Value="{StaticResource RadioButton.Static.Background}"/>
            <Setter Property="BorderBrush" Value="{StaticResource RadioButton.Static.Border}"/>
            <Setter Property="Foreground" Value="{DynamicResource {x:Static SystemColors.ControlTextBrushKey}}"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="SnapsToDevicePixels" Value="True"/>
            <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type ToggleButton}">
                        <Grid x:Name="templateRoot" 
							  Background="Transparent" 
							  SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}">
                            <VisualStateManager.VisualStateGroups>
                                <VisualStateGroup x:Name="CommonStates">
                                    <VisualState x:Name="Normal"/>
                                    <VisualState x:Name="MouseOver">
                                        <Storyboard>
                                            <DoubleAnimation To="0" Duration="0:0:0.2" Storyboard.TargetName="normalBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <DoubleAnimation To="1" Duration="0:0:0.2" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0:0:0.2">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="Fill" Duration="0:0:0.2">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Pressed">
                                        <Storyboard>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="pressedBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Pressed.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Disabled">
                                        <Storyboard>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                </VisualStateGroup>
                                <VisualStateGroup x:Name="CheckStates">
                                    <VisualState x:Name="Unchecked"/>
                                    <VisualState x:Name="Checked">
                                        <Storyboard>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Static.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimationUsingKeyFrames Duration="0:0:0.5" Storyboard.TargetProperty="(UIElement.RenderTransform).(TransformGroup.Children)[3].(TranslateTransform.X)" Storyboard.TargetName="optionMark">
                                                <EasingDoubleKeyFrame KeyTime="0" Value="12"/>
                                            </DoubleAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Checked.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Indeterminate"/>
                                </VisualStateGroup>
                                <VisualStateGroup x:Name="FocusStates">
                                    <VisualState x:Name="Unfocused"/>
                                    <VisualState x:Name="Focused"/>
                                </VisualStateGroup>
                            </VisualStateManager.VisualStateGroups>
                            <Grid.RowDefinitions>
                                <RowDefinition />
                                <RowDefinition Height="Auto"/>
                            </Grid.RowDefinitions>
                            <ContentPresenter x:Name="contentPresenter" 
											  Focusable="False" RecognizesAccessKey="True" 
											  HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" 
											  Margin="{TemplateBinding Padding}" 
											  SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}" 
											  VerticalAlignment="{TemplateBinding VerticalContentAlignment}"/>
                            <Grid x:Name="markGrid" Grid.Row="1" Margin="10 0 10 0" Width="44" Height="20"
								  HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}">
                                <Border x:Name="normalBorder" Opacity="1" BorderThickness="2" CornerRadius="10"
										BorderBrush="{TemplateBinding BorderBrush}" Background="{StaticResource RadioButton.Static.Background}"/>
                                <Border x:Name="checkedBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource  RadioButton.Checked.Border}" Background="{StaticResource RadioButton.Checked.Background}"/>
                                <Border x:Name="hoverBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.MouseOver.Border}" Background="{StaticResource RadioButton.MouseOver.Background}"/>
                                <Border x:Name="pressedBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.Pressed.Border}" Background="{StaticResource RadioButton.Pressed.Background}"/>
                                <Border x:Name="disabledBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.Disabled.Border}" Background="{StaticResource RadioButton.Disabled.Background}"/>
                                <Ellipse x:Name="optionMark"
										 Height="10" Width="10" Fill="{StaticResource RadioButton.Static.Glyph}" StrokeThickness="0" 
										 VerticalAlignment="Center" Margin="5,0" RenderTransformOrigin="0.5,0.5">
                                    <Ellipse.RenderTransform>
                                        <TransformGroup>
                                            <ScaleTransform/>
                                            <SkewTransform/>
                                            <RotateTransform/>
                                            <TranslateTransform X="-12"/>
                                        </TransformGroup>
                                    </Ellipse.RenderTransform>
                                </Ellipse>
                                <Ellipse x:Name="optionMarkOn" Opacity="0"
										 Height="10" Width="10" Fill="{StaticResource RadioButton.Checked.Glyph}" StrokeThickness="0" 
										 VerticalAlignment="Center" Margin="5,0" RenderTransformOrigin="0.5,0.5">
                                    <Ellipse.RenderTransform>
                                        <TransformGroup>
                                            <ScaleTransform/>
                                            <SkewTransform/>
                                            <RotateTransform/>
                                            <TranslateTransform X="12"/>
                                        </TransformGroup>
                                    </Ellipse.RenderTransform>
                                </Ellipse>
                            </Grid>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>        

        <Style x:Key="ToggleSwitchTopStyle" TargetType="{x:Type ToggleButton}">
            <Setter Property="Background" Value="{StaticResource RadioButton.Static.Background}"/>
            <Setter Property="BorderBrush" Value="{StaticResource RadioButton.Static.Border}"/>
            <Setter Property="Foreground" Value="{DynamicResource {x:Static SystemColors.ControlTextBrushKey}}"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="SnapsToDevicePixels" Value="True"/>
            <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type ToggleButton}">
                        <Grid x:Name="templateRoot" 
							  Background="Transparent" 
							  SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}">
                            <VisualStateManager.VisualStateGroups>
                                <VisualStateGroup x:Name="CommonStates">
                                    <VisualState x:Name="Normal"/>
                                    <VisualState x:Name="MouseOver">
                                        <Storyboard>
                                            <DoubleAnimation To="0" Duration="0:0:0.2" Storyboard.TargetName="normalBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <DoubleAnimation To="1" Duration="0:0:0.2" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0:0:0.2">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="Fill" Duration="0:0:0.2">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Pressed">
                                        <Storyboard>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="pressedBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Pressed.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Disabled">
                                        <Storyboard>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                </VisualStateGroup>
                                <VisualStateGroup x:Name="CheckStates">
                                    <VisualState x:Name="Unchecked"/>
                                    <VisualState x:Name="Checked">
                                        <Storyboard>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Static.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimationUsingKeyFrames Duration="0:0:0.5" Storyboard.TargetProperty="(UIElement.RenderTransform).(TransformGroup.Children)[3].(TranslateTransform.X)" Storyboard.TargetName="optionMark">
                                                <EasingDoubleKeyFrame KeyTime="0" Value="12"/>
                                            </DoubleAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Checked.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Indeterminate"/>
                                </VisualStateGroup>
                                <VisualStateGroup x:Name="FocusStates">
                                    <VisualState x:Name="Unfocused"/>
                                    <VisualState x:Name="Focused"/>
                                </VisualStateGroup>
                            </VisualStateManager.VisualStateGroups>
                            <Grid.RowDefinitions>
                                <RowDefinition />
                                <RowDefinition Height="Auto"/>
                            </Grid.RowDefinitions>
                            <ContentPresenter x:Name="contentPresenter" 
											  Focusable="False" RecognizesAccessKey="True" 
											  HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" 
											  Margin="{TemplateBinding Padding}" 
											  SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}" 
											  VerticalAlignment="{TemplateBinding VerticalContentAlignment}"/>
                            <Grid x:Name="markGrid" Grid.Row="1" Margin="0 8 0 2" Width="44" Height="20"
								  HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}">
                                <Border x:Name="normalBorder" Opacity="1" BorderThickness="2" CornerRadius="10"
										BorderBrush="{TemplateBinding BorderBrush}" Background="Transparent"/>
                                <Border x:Name="checkedBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource  RadioButton.Checked.Border}" Background="{StaticResource RadioButton.Checked.Background}"/>
                                <Border x:Name="hoverBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.MouseOver.Border}" Background="Transparent"/>
                                <Border x:Name="pressedBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.Pressed.Border}" Background="{StaticResource RadioButton.Pressed.Background}"/>
                                <Border x:Name="disabledBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.Disabled.Border}" Background="{StaticResource RadioButton.Disabled.Background}"/>
                                <Ellipse x:Name="optionMark"
										 Height="10" Width="10" Fill="{StaticResource RadioButton.Static.Glyph}" StrokeThickness="0" 
										 VerticalAlignment="Center" Margin="5,0" RenderTransformOrigin="0.5,0.5">
                                    <Ellipse.RenderTransform>
                                        <TransformGroup>
                                            <ScaleTransform/>
                                            <SkewTransform/>
                                            <RotateTransform/>
                                            <TranslateTransform X="-12"/>
                                        </TransformGroup>
                                    </Ellipse.RenderTransform>
                                </Ellipse>
                                <Ellipse x:Name="optionMarkOn" Opacity="0"
										 Height="10" Width="10" Fill="{StaticResource RadioButton.Checked.Glyph}" StrokeThickness="0" 
										 VerticalAlignment="Center" Margin="5,0" RenderTransformOrigin="0.5,0.5">
                                    <Ellipse.RenderTransform>
                                        <TransformGroup>
                                            <ScaleTransform/>
                                            <SkewTransform/>
                                            <RotateTransform/>
                                            <TranslateTransform X="12"/>
                                        </TransformGroup>
                                    </Ellipse.RenderTransform>
                                </Ellipse>
                            </Grid>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="TextBlockStyle" TargetType="{x:Type TextBlock}">
            <Setter Property="FontFamily" Value="Segoe UI"/>
            <Setter Property="FontSize" Value="16"/>
            <Setter Property="TextOptions.TextFormattingMode" Value="Display"/>
            <Setter Property="Foreground" Value="Black"/>
        </Style>

        <SolidColorBrush x:Key="Hover.Enter.Brush" Color="#FFF2F2F2" />
        <SolidColorBrush x:Key="Hover.Exit.Brush" Color="#01FFFFFF" />

        <Storyboard x:Key="Hover.Enter.Storyboard"/>

        <Storyboard x:Key="Hover.Exit.Storyboard"/>

        <Style x:Key="HoverBorder" TargetType="Border">
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Margin" Value="0 4"/>
            <Setter Property="Padding" Value="10 2"/>
            <Style.Triggers>
                <EventTrigger RoutedEvent="Mouse.MouseEnter">
                    <BeginStoryboard Storyboard="{StaticResource Hover.Enter.Storyboard}" />
                </EventTrigger>
                <EventTrigger RoutedEvent="Mouse.MouseLeave">
                    <BeginStoryboard Storyboard="{StaticResource Hover.Exit.Storyboard}" />
                </EventTrigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="TitleButtonStyle" TargetType="Canvas">
            <Setter Property="Height" Value="35"/>
            <Setter Property="Width" Value="35"/>
            <Style.Triggers>
                <Trigger Property="Canvas.IsMouseOver" Value="True">
                    <Setter Property="Canvas.Background" Value="#FF1744"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="ButtonTextBlock" TargetType="{x:Type TextBlock}">
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Margin" Value="0 5 0 0"/>
        </Style>

    </Window.Resources>

    <Border Name="BorderWindow" BorderThickness="1" BorderBrush="#0078d7">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="40"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>                
            </Grid.RowDefinitions>
            <!--#region Title Panel-->
            <Grid Grid.Row="0" Margin="0 0 0 5" Background="{Binding ElementName=BorderWindow, Path=BorderBrush}">
                <Grid.Effect>
                    <DropShadowEffect ShadowDepth="2" Direction="315" BlurRadius="3" Opacity="0.5"/>
                </Grid.Effect>
                <!--Icon-->
                <Viewbox Width="28" Height="28" HorizontalAlignment="Left" Margin="10 0 0 3">
                    <Canvas Width="24" Height="24">
                        <Path Data="M3,12V6.75L9,5.43V11.91L3,12M20,3V11.75L10,11.9V5.21L20,3M3,13L9,13.09V19.9L3,18.75V13M20,13.25V22L10,20.09V13.1L20,13.25Z" Fill="{Binding ElementName=TitleHeader,Path=Foreground}" />
                    </Canvas>
                </Viewbox>
                <!--Header-->
                <TextBlock Name="TitleHeader" Text="Windows 10 Setup Script" FontFamily="Sergio UI" FontSize="14"
                           FontWeight="Bold" VerticalAlignment="Center" HorizontalAlignment="Center" Foreground="#FFFFFF"/>
                <!--Minimize Button-->
                <Canvas Name="MinimizeButton" VerticalAlignment="Center" HorizontalAlignment="Right" 
                        Margin="0 0 35 0" Style="{StaticResource TitleButtonStyle}">
                    <Viewbox Width="24" Height="24" Canvas.Left="4">
                        <Path  Data="M20,14H4V10H20" Fill="{Binding ElementName=TitleHeader,Path=Foreground}" />
                    </Viewbox>
                </Canvas>
                <!--Close Button-->
                <Canvas Name="CloseButton" VerticalAlignment="Center" HorizontalAlignment="Right" Style="{StaticResource TitleButtonStyle}">
                    <Viewbox Width="24" Height="24" Canvas.Left="4" Canvas.Top="2">
                        <Path Data="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" Fill="{Binding ElementName=TitleHeader,Path=Foreground}" />
                    </Viewbox>
                </Canvas>
            </Grid>
            <!--#endregion Title Panel-->

            <!--#region Action Buttons Panel-->
            <StackPanel Name="ActionButtonsPanel" Height="40" Margin="0 0 0 5" Orientation="Horizontal" Grid.Row="1" VerticalAlignment="Center" HorizontalAlignment="Center">

                <!--#region Apply Setting Button-->
                <StackPanel Margin="10 0 0 0" Height="35" Width="35" Orientation="Horizontal">
                    <StackPanel.Style>
                        <Style TargetType="{x:Type StackPanel}">
                            <Style.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter Property="Background" Value="#DADADA"/>
                                </Trigger>
                                <Trigger Property="IsMouseOver" Value="False">
                                    <Setter Property="Background" Value="{Binding ElementName=Window, Path=Background}"/>
                                </Trigger>
                                <EventTrigger RoutedEvent="MouseEnter">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="130" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseLeave">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="35" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseDown">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <ThicknessAnimation Storyboard.TargetProperty="Margin" Duration="0:0:0.5" To="10 4 0 0" SpeedRatio="5" AutoReverse="True" />
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                            </Style.Triggers>
                        </Style>
                    </StackPanel.Style>
                    <Viewbox Width="18" Height="18" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="8 0 9 0">
                        <Canvas Width="24" Height="24">
                            <Path Data="M11,15H13V17H11V15M11,7H13V13H11V7M12,2C6.47,2 2,6.5 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20Z"
                                  Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="ApplyButtonText" Text="apply settings" FontSize="14" VerticalAlignment="Center"
                               Margin="0 0 8 0" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                </StackPanel>
                <!--#endregion Apply Button-->

                <!--#region Save Setting Button-->
                <StackPanel Margin="10 0 0 0" Height="35" Width="35" Orientation="Horizontal">
                    <StackPanel.Style>
                        <Style TargetType="{x:Type StackPanel}">
                            <Style.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter Property="Background" Value="#DADADA"/>
                                </Trigger>
                                <Trigger Property="IsMouseOver" Value="False">
                                    <Setter Property="Background" Value="{Binding ElementName=Window, Path=Background}"/>
                                </Trigger>
                                <EventTrigger RoutedEvent="MouseEnter">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="125" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseLeave">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="35" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseDown">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <ThicknessAnimation Storyboard.TargetProperty="Margin" Duration="0:0:1" To="10 4 0 0" SpeedRatio="5" AutoReverse="True"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                            </Style.Triggers>
                        </Style>
                    </StackPanel.Style>
                    <Viewbox Width="18" Height="18" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="8 0 9 0">
                        <Canvas Width="24" Height="24">
                            <Path Data="M12,2A3,3 0 0,0 9,5C9,6.27 9.8,7.4 11,7.83V10H8V12H11V18.92C9.16,18.63 7.53,17.57 6.53,16H8V14H3V19H5V17.3C6.58,19.61 9.2,21 12,21C14.8,21 17.42,19.61 19,17.31V19H21V14H16V16H17.46C16.46,17.56 14.83,18.63 13,18.92V12H16V10H13V7.82C14.2,7.4 15,6.27 15,5A3,3 0 0,0 12,2M12,4A1,1 0 0,1 13,5A1,1 0 0,1 12,6A1,1 0 0,1 11,5A1,1 0 0,1 12,4Z"
                                  Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="SaveButtonText" Text="save settings" FontSize="14" VerticalAlignment="Center"
                               Margin="0 0 8 0" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                </StackPanel>
                <!--#endregion Save Setting Button-->

                <!--#region Load Setting Button-->
                <StackPanel Margin="10 0 0 0" Height="35" Width="35" Orientation="Horizontal">
                    <StackPanel.Style>
                        <Style TargetType="{x:Type StackPanel}">
                            <Style.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter Property="Background" Value="#DADADA"/>
                                </Trigger>
                                <Trigger Property="IsMouseOver" Value="False">
                                    <Setter Property="Background" Value="{Binding ElementName=Window, Path=Background}"/>
                                </Trigger>
                                <EventTrigger RoutedEvent="MouseEnter">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="125" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseLeave">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="35" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseDown">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <ThicknessAnimation Storyboard.TargetProperty="Margin" Duration="0:0:1" To="10 4 0 0" SpeedRatio="5" AutoReverse="True"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                            </Style.Triggers>
                        </Style>
                    </StackPanel.Style>
                    <Viewbox Width="18" Height="18" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="8 0 9 0">
                        <Canvas Width="24" Height="24">
                            <Path Data="M7.5,5.6L5,7L6.4,4.5L5,2L7.5,3.4L10,2L8.6,4.5L10,7L7.5,5.6M19.5,15.4L22,14L20.6,16.5L22,19L19.5,17.6L17,19L18.4,16.5L17,14L19.5,15.4M22,2L20.6,4.5L22,7L19.5,5.6L17,7L18.4,4.5L17,2L19.5,3.4L22,2M13.34,12.78L15.78,10.34L13.66,8.22L11.22,10.66L13.34,12.78M14.37,7.29L16.71,9.63C17.1,10 17.1,10.65 16.71,11.04L5.04,22.71C4.65,23.1 4,23.1 3.63,22.71L1.29,20.37C0.9,20 0.9,19.35 1.29,18.96L12.96,7.29C13.35,6.9 14,6.9 14.37,7.29Z" 
                                  Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="LoadButtonText" Text="load settings" FontSize="14" VerticalAlignment="Center"
                               Margin="0 0 8 0" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                </StackPanel>
                <!--#endregion Load Setting Button-->

                <!--#region Change Language Button-->
                <StackPanel Margin="10 0 0 0" Height="35" Width="35" Orientation="Horizontal">
                    <StackPanel.Style>
                        <Style TargetType="{x:Type StackPanel}">
                            <Style.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter Property="Background" Value="#DADADA"/>
                                </Trigger>
                                <Trigger Property="IsMouseOver" Value="False">
                                    <Setter Property="Background" Value="{Binding ElementName=Window, Path=Background}"/>
                                </Trigger>
                                <EventTrigger RoutedEvent="MouseEnter">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="150" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseLeave">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="35" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseDown">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <ThicknessAnimation Storyboard.TargetProperty="Margin" Duration="0:0:1" To="10 4 0 0" SpeedRatio="5" AutoReverse="True"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                            </Style.Triggers>
                        </Style>
                    </StackPanel.Style>
                    <Viewbox Width="18" Height="18" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="8 0 9 0">
                        <Canvas Width="24" Height="24">
                            <Path Data="M16.36,14C16.44,13.34 16.5,12.68 16.5,12C16.5,11.32 16.44,10.66 16.36,10H19.74C19.9,10.64 20,11.31 20,12C20,12.69 19.9,13.36 19.74,14M14.59,19.56C15.19,18.45 15.65,17.25 15.97,16H18.92C17.96,17.65 16.43,18.93 14.59,19.56M14.34,14H9.66C9.56,13.34 9.5,12.68 9.5,12C9.5,11.32 9.56,10.65 9.66,10H14.34C14.43,10.65 14.5,11.32 14.5,12C14.5,12.68 14.43,13.34 14.34,14M12,19.96C11.17,18.76 10.5,17.43 10.09,16H13.91C13.5,17.43 12.83,18.76 12,19.96M8,8H5.08C6.03,6.34 7.57,5.06 9.4,4.44C8.8,5.55 8.35,6.75 8,8M5.08,16H8C8.35,17.25 8.8,18.45 9.4,19.56C7.57,18.93 6.03,17.65 5.08,16M4.26,14C4.1,13.36 4,12.69 4,12C4,11.31 4.1,10.64 4.26,10H7.64C7.56,10.66 7.5,11.32 7.5,12C7.5,12.68 7.56,13.34 7.64,14M12,4.03C12.83,5.23 13.5,6.57 13.91,8H10.09C10.5,6.57 11.17,5.23 12,4.03M18.92,8H15.97C15.65,6.75 15.19,5.55 14.59,4.44C16.43,5.07 17.96,6.34 18.92,8M12,2C6.47,2 2,6.5 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2Z"
                                  Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="ChangeLanguageButtonText" Text="change language" FontSize="14" VerticalAlignment="Center"
                               Margin="0 0 8 0" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                </StackPanel>
                <!--#endregion Change Language Button-->

                <!--#region Github Button-->
                <StackPanel Margin="10 0 0 0" Height="35" Width="35" Orientation="Horizontal">
                    <StackPanel.Style>
                        <Style TargetType="{x:Type StackPanel}">
                            <Style.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter Property="Background" Value="#DADADA"/>
                                </Trigger>
                                <Trigger Property="IsMouseOver" Value="False">
                                    <Setter Property="Background" Value="{Binding ElementName=Window, Path=Background}"/>
                                </Trigger>
                                <EventTrigger RoutedEvent="MouseEnter">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="135" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseLeave">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="35" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseDown">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <ThicknessAnimation Storyboard.TargetProperty="Margin" Duration="0:0:1" To="10 4 0 0" SpeedRatio="5" AutoReverse="True"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                            </Style.Triggers>
                        </Style>
                    </StackPanel.Style>
                    <Viewbox Width="18" Height="18" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="8 0 9 0">
                        <Canvas Width="24" Height="24">
                            <Path Data="M12,2A10,10 0 0,0 2,12C2,16.42 4.87,20.17 8.84,21.5C9.34,21.58 9.5,21.27 9.5,21C9.5,20.77 9.5,20.14 9.5,19.31C6.73,19.91 6.14,17.97 6.14,17.97C5.68,16.81 5.03,16.5 5.03,16.5C4.12,15.88 5.1,15.9 5.1,15.9C6.1,15.97 6.63,16.93 6.63,16.93C7.5,18.45 8.97,18 9.54,17.76C9.63,17.11 9.89,16.67 10.17,16.42C7.95,16.17 5.62,15.31 5.62,11.5C5.62,10.39 6,9.5 6.65,8.79C6.55,8.54 6.2,7.5 6.75,6.15C6.75,6.15 7.59,5.88 9.5,7.17C10.29,6.95 11.15,6.84 12,6.84C12.85,6.84 13.71,6.95 14.5,7.17C16.41,5.88 17.25,6.15 17.25,6.15C17.8,7.5 17.45,8.54 17.35,8.79C18,9.5 18.38,10.39 18.38,11.5C18.38,15.32 16.04,16.16 13.81,16.41C14.17,16.72 14.5,17.33 14.5,18.26C14.5,19.6 14.5,20.68 14.5,21C14.5,21.27 14.66,21.59 15.17,21.5C19.14,20.16 22,16.42 22,12A10,10 0 0,0 12,2Z"
                                  Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="GithubButtonText" Text="follow to githib" FontSize="14" VerticalAlignment="Center"
                               Margin="0 0 8 0" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                </StackPanel>
                <!--#endregion Change Language Button-->
            </StackPanel>
            <!--#endregion Action Buttons Panel-->

            <!--#region Alert Panel-->
            <StackPanel Name="AlertPanel" Height="50" Visibility="Collapsed" Orientation="Horizontal" Grid.Row="2" VerticalAlignment="Center">

            </StackPanel>
            <!--#endregion Alert Panel-->

            <!--#region Toggle Buttons Panel-->
            <ScrollViewer Grid.Row="3" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Disabled">
                <!--#region Privacy & Telemetry-->
                <StackPanel Orientation="Vertical" VerticalAlignment="Top">
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Height="43" Background="#FFFFFF">
                        <TextBlock Name="PanelHeaderPrivacy" Text="Privacy &amp; Telemetry Settings" FontSize="16" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="28 0 0 0"/>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch0" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Change Windows Feedback frequency to &quot;Never&quot;" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch0, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Change Windows Feedback frequency to &quot;Never&quot;"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch0, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch1" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Turn off automatic installing suggested apps" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch1, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Turn off automatic installing suggested apps"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch1, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch2" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Turn off &quot;Connected User Experiences and Telemetry&quot; service" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch2, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Turn off &quot;Connected User Experiences and Telemetry&quot; service"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch2, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch3" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Turn off the SQMLogger session at the next computer restart" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch3, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Turn off the SQMLogger session at the next computer restart"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch3, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch4" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Do not allow apps to use advertising ID" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch4, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Do not allow apps to use advertising ID"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch4, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch5" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Do not use sign-in info to automatically finish setting up device after an update or restart" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch5, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Do not use sign-in info to automatically finish setting up device after an update or restart"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch5, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch6" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Do not let websites provide locally relevant content by accessing language list" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch6, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Do not let websites provide locally relevant content by accessing language list"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch6, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch7" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Turn off suggested content in the Settings" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch7, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Turn off suggested content in the Settings"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch7, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch8" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Turn off tip, trick, and suggestions as you use Windows" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch8, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Turn off tip, trick, and suggestions as you use Windows"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch8, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch9" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Turn off reserved storage" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch9, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Turn off reserved storage"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch9, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch10" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Do not let apps on other devices open and message apps on this device, and vice versa" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch10, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Do not let apps on other devices open and message apps on this device, and vice versa"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch10, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch11" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Set the operating system diagnostic data level to &quot;Basic&quot;" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch11, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Set the operating system diagnostic data level to &quot;Basic&quot;"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch11, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch12" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Turn off the Autologger session at the next computer restart" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch12, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Turn off the Autologger session at the next computer restart"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch12, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch13" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Turn off per-user services" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch13, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Turn off per-user services"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch13, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch14" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Do not offer tailored experiences based on the diagnostic data setting" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch14, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Do not offer tailored experiences based on the diagnostic data setting"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch14, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch15" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Turn off diagnostics tracking scheduled tasks" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch15, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Turn off diagnostics tracking scheduled tasks"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch15, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
                        <StackPanel Orientation="Horizontal" Margin="10">
                            <Grid HorizontalAlignment="Left">
                                <ToggleButton Name="ToggleSwitch16" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                <TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
                                            <Setter Property="Text" Value="Turn off Windows Error Reporting" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch16, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="Turn off Windows Error Reporting"/>
                                                    <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=ToggleSwitch16, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                            </Grid>
                        </StackPanel>
                    </Border>
                    <!--Placeholder Panel-->
                    <StackPanel Margin="10 0 10 0" Height="43" Background="Transparent"/>
                </StackPanel>
                <!--#endregion Privacy & Telemetry-->


            </ScrollViewer>
            <!--#endregion Toggle Buttons Panel-->            
        </Grid>
    </Border>
</Window>
'@

$xamlGui = [System.Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xamlMarkup))
$xamlMarkup.SelectNodes('//*[@Name]') | ForEach-Object {
    
    if ($_.Name.Contains("ToggleButton")) {

        $ToggleBtn = $xamlGui.FindName($_.Name)
        [Void]$ToggleButtons.Add($ToggleBtn)
    }
	
	else
	{
		New-Variable -Name $_.Name -Value $xamlGui.FindName($_.Name)
	}    
}

#region Script Functions
function Hide-Console {
    <#
    .SYNOPSIS
    Hide Powershell console before show WPF GUI.    
    #>

    [CmdletBinding()]
    param ()

    Add-Type -Name Window -Namespace Console -MemberDefinition '
    [DllImport("Kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
    [Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)
}

#endregion

#region Controls Events

$xamlGui.add_MouseLeftButtonDown( {
        $xamlGui.DragMove()
    })

$MinimizeButton.add_MouseLeftButtonDown( {
        $xamlGui.WindowState = "Minimized"
    })

$CloseButton.add_MouseLeftButtonDown( {
        $xamlGui.Close()
    })

#endregion

Hide-Console
$xamlGui.ShowDialog() | Out-Null