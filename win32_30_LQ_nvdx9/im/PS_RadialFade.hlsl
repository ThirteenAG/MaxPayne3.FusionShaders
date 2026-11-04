float4 RadialFadeArea : register(c213);
float4 RadialFadeTime : register(c214);
float4 RadialWaveParam : register(c215);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float2 r2;
	r0.xy = -RadialFadeArea.xy + texcoord.xy;
	r0.zw = abs(r0.xy) + -RadialFadeArea.zw;
	r0.zw = (r0.zw >= 0) ? 0 : 1;
	r0.z = r0.w * r0.z;
	r1 = -r0.z;
	clip(r1);
	r1.yz = float2(1, 2);
	r0.z = RadialFadeTime.w * -r1.z + r1.y;
	r0.z = saturate(r0.z * RadialFadeTime.x + RadialFadeTime.w);
	r2 = lerp(RadialFadeArea.zw, r1.yy, r0.zz);
	r0.z = 1 / r2.y;
	r0.z = r0.z * r2.x;
	r0.y = r0.z * abs(r0.y);
	r1.x = max(abs(r0.x), r0.y);
	r0.x = -r2.x + r1.x;
	o.w = RadialWaveParam.x * r0.x + RadialWaveParam.y;
	o.xyz = 0;

	return o;
}
