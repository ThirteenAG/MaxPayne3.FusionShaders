sampler2D DiffuseSampler : register(s0);
float3 dirtDecalMask : register(c196);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 globalScalars : register(c35);
float specularColorFactor : register(c198);
float specularFactor : register(c197);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color2 : COLOR2;
	float4 color1 : COLOR1;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.w = dot(r0.xyz, dirtDecalMask.xyz);
	r0.xyz = 1;
	r1 = r0 * i.color;
	r0.w = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r2 = r0.xyz * i.color.xyz + -r0.www;
	r2 = gAdrenoFXVars.xxx * r2.xyz + r0.www;
	r0.xyz = r0.xyz * -i.color.xyz + r2.xyz;
	r0.w = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	o.color.xyz = r0.www * r0.xyz + r1.xyz;
	r0.w = r1.w * globalScalars.x;
	r1.xzw = float3(0.0051020407, 0, 1);
	r0.y = saturate(r1.x * specularFactor.x);
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	r1.x = 1;
	r1.x = r1.x + -specularFactor.x;
	o.color2.y = (r1.x >= 0) ? 0.071428575 : r0.y;
	o.color.w = r0.w;
	o.color1 = 0;
	r0.xz = r1.wz * specularColorFactor.xx;
	o.color2.xzw = r0.xzw;
	o.color3 = r0.zzzw;

	return o;
}
