sampler2D DiffuseSampler : register(s0);
float3 dirtDecalMask : register(c196);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 globalScalars : register(c35);
float specularColorFactor : register(c198);
float specularFactor : register(c197);
float4 stipplePattern : register(c62);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float2 vpos : VPOS;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
	float4 color1 : COLOR1;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float3 r4;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.w = dot(r0.xyz, dirtDecalMask.xyz);
	r0.xyz = 1;
	r1 = r0 * i.color;
	r2.w = r1.w * globalScalars.x;
	r3.xy = 0.5 * i.vpos.xy;
	r3.xy = frac(abs(r3.xy));
	r3.xy = (i.vpos.xy >= 0) ? r3.xy : -r3.xy;
	r3.xy = r3.xy + r3.xy;
	r3.zw = frac(r3.xy);
	r3.xy = -r3.zw + r3.xy;
	r0.w = r3.y * 2 + r3.x;
	r3 = r0.w + float4(-0, -1, -2, -3);
	r3 = (-abs(r3) >= 0) ? 1 : 0;
	r0.w = dot(stipplePattern, r3);
	r0.w = r1.w * -globalScalars.x + r0.w;
	r3 = (r0.w >= 0) ? -1 : -0;
	clip(r3);
	r3.xw = float2(1, 0);
	r0.w = r3.x + -specularFactor.x;
	r1.w = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r4 = r0.xyz * i.color.xyz + -r1.www;
	r4 = gAdrenoFXVars.xxx * r4.xyz + r1.www;
	r1.w = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r0.xyz = r0.xyz * -i.color.xyz + r4.xyz;
	o.color.xyz = r1.www * r0.xyz + r1.xyz;
	r1.w = 0.0051020407;
	r0.x = saturate(r1.w * specularFactor.x);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.color2.y = (r0.w >= 0) ? 0.071428575 : r0.x;
	o.color.w = r2.w;
	r2.xz = r3.xw * specularColorFactor.xx;
	o.color2.xzw = r2.xzw;
	o.color3 = r2.zzzw;
	o.color1 = 0;

	return o;
}
