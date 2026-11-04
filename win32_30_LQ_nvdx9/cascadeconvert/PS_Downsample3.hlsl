sampler2D ConvertSampler : register(s0);
float4 DofProj : register(c198);
float4 gShadowParam18192021 : register(c51);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0.x = 0.5;
	r1.z = gShadowParam18192021.x * r0.x + texcoord.x;
	r1.xyw = gShadowParam18192021.xyy * -r0.xxx + texcoord.xyy;
	r2 = tex2D(ConvertSampler, r1.zw);
	r1 = tex2D(ConvertSampler, r1.xy);
	r1.y = r2.x;
	r2.x = gShadowParam18192021.x * -r0.x + texcoord.x;
	r2.yzw = gShadowParam18192021.yxy * r0.xxx + texcoord.yxy;
	r0 = tex2D(ConvertSampler, r2.xy);
	r2 = tex2D(ConvertSampler, r2.zw);
	r1.w = r2.x;
	r1.z = r0.x;
	r0 = lerp(DofProj.x, DofProj.y, r1);
	r0 = r0 + DofProj.z;
	r1.x = dot(r0, 1);
	r1.y = dot(r0, r0);
	r1.zw = float2(0, 4);
	o = r1 * 0.25;

	return o;
}
